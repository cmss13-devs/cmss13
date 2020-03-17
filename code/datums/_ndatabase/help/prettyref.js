(function(){	// IE shim
	if((typeof Node === "undefined") || !Node.prototype.hasOwnProperty('textContent')) {	// IE8
		var nodeValue = Object.getOwnPropertyDescriptor(Text.prototype, "nodeValue");
		Object.defineProperty(Text.prototype, "textContent", {
		        get: function() {return nodeValue.get.call(this);},
		        set: function(x) {return nodeValue.set.call(this,x);}
		});
		var innerText = Object.getOwnPropertyDescriptor(Element.prototype, "innerText");
		Object.defineProperty(Element.prototype, "textContent", {
			get: function() {return innerText.get.call(this);},
		        set: function(x) {
	        	        var c;
		                while((c=this.firstChild)) this.removeChild(c);
		                if(x!==null) {
        	        	        c=document.createTextNode(x);
                		        this.appendChild(c);
		                }
		                c=null;
		                return x;
		        }
		});
	}
})();

function now() {return (new Date()).getTime();}

function toArray(a) {
	try {return Array.prototype.slice.call(a);}
	catch(e) {
		var result=[],i,l;
		for(i=0,l=a.length; i<l; ++i) result.push(a[i]);
		return result;
	}
}

function prevElem(e) {
	e = e.previousSibling;
	while(e && e.nodeType != 1) e = e.previousSibling;
	return e;
}

/*
	State bitflags:
	Bit 0: extended
	Bit 1: string
	Bit 2: comment
	Bit 3: preprocessor
	Bit 4: brace
	Bit 5: single-quoted string
	Bit 6: keyword
	Bit 7: num
	Bit 8: identifier
	Bit 9: raw string
 */
function DMhighlight(pre, params) {
	function own(a,b) {return a.hasOwnProperty(b);}
	function ext(a,b) {
		for(var k in b) {if(own(b,k)) a[k] = b[k];}
		return a;
	}

	var dm_keywords_rx = /^(break|new|del|for|global|var|proc|verb|set|static|arg|const|goto|if|in|as|continue|return|do|while|else|sleep|spawn|switch|tmp|to)$/;
	params = params || {};
	var hl = ext({num:true}, params.highlight);
	var use_ids = !!hl.id;
	var use_nums = !!hl.num;
	var keepTabs = !!params.keepTabs;
	var tablen = params.tabs || 4;

	var fulltab = '';
	for(var i=0; i<tablen; ++i) fulltab += ' ';

	function DM_nodes(txt) {
		var nodes = [], stack = [];
		var state = 0;
		var i,j,len,id;
		var sol,sos,ch;
		txt = txt.replace(/\r/g,'');
		if(params.trim != false) {
			txt = txt.replace(/^(\s*\n)*/g, '');
			txt = txt.replace(/[\s\n]*$/g, '');
		}
		if(!keepTabs) {
			do {
				i = txt;
				txt = txt.replace(/^(\t*)\t/gm,'$1'+fulltab);
			} while(i != txt);
			do {
				i = txt;
				txt = txt.replace(/^([^\t\n]+)\t/gm,function(m,a){
					j = a.length % tablen;
					do {a += ' '; ++j;} while(j < tablen);
					return a;
				});
			} while(i != txt);
			txt = txt.replace(/^\t/gm,fulltab);
		}
		len = txt.length;

		function change_state(new_state,at) {
			if(new_state != state && sos != at) {
				var sname=null,n;
				if(state & 0x222) sname = "s";
				else if(state & 4) sname = "c";
				else if(state & 8) sname = "pp";
				else if(state & 0x40) sname = "k";
				else if(state & 0x80) sname = "n";
				else if(state & 0x100) sname = "i";
				if((n=nodes[nodes.length-1]) && n.state == sname)
					n.text += txt.substr(sos,at-sos);
				else
					nodes.push({state:sname, text:txt.substr(sos,at-sos)});
				sos = at;
			}
			state = new_state;
		}

		function is_top_state() {
			return !state && !stack.length;
		}

		function pop_state(at) {
			if(stack.length) change_state(stack.pop(),at);
			else if(state) change_state(0);
			else return false;
			return true;
		}

		function push_state(new_state,at) {
			if(new_state != state) {
				stack.push(state);
				change_state(new_state, at);
			}
		}

		function parse_number() {	// already got first character in ch
			var dec,e,at;
			if(ch == '0') {	// hex, octal, or 0.xxxx which is decimal
				ch = txt[i];
				if(ch == 'x') {	// hex
					while(++i<len && txt[i].match(/[a-f]/i));
					return;
				}
				if(ch >= '0' && ch <= '7') {	// octal
					while(++i<len && txt[i].match(/[0-7]/i));
					return;
				}
			}
			while(i<len) {
				ch = txt[at=i];
				if(ch == '.') {
					if(dec) return;
					ch = txt[++i];
					// fall through to digit test -- always expect digit after decimal
				}
				else if(ch == 'e' || ch == 'E') {
					if(e) return;
					dec = e = true;
					ch = txt[++i];
					if(ch == '+' || ch == '-') ch = txt[++i];
					// fall through to digit test -- always expect digit after e and optional sign
				}
				if(ch < '0' || ch > '9') {i=at; return;}
				++i;
			}
		}

		function parse_id() {
			var at=i-1;
			while(i<len) {
				ch = txt[i];
				if(ch == '_' || (ch >= 'A' && ch <= 'Z') || (ch >= 'a' && ch <= 'z') || (ch >= '0' && ch <= '9')) ++i;
				else break;
			}
			return txt.substr(at,i-at);
		}

		function parse_raw_str() {
			var d,k=i,e,n;
			if(k >= len) return;
			ch = txt[k++];
			if(ch == '{') {
				if(k >= len || txt[k++] != '"') return;
				d = "\"}";
			}
			else if(ch == '(') {
				if((e=txt.indexOf(')',k))<0 || ((n=txt.indexOf('\n',k))>=0 && n<e)) return;
				d = txt.substring(k,e); k=e++;
			}
			else {
				if((e=txt.indexOf(ch,k))<0 || ((n=txt.indexOf('\n',k))>=0 && n<e)) return;
				d = ch;
			}
			k = txt.indexOf(d,k);
			if(k >= 0) {push_state(0x200, i-1); pop_state(i=k+d.length);}
			return;
		}

		for(i=sol=sos=0; i<len;) {
			ch = txt[i++];
			switch(ch) {
				case '\n':
					while(i<len && txt[i]=='\n') ++i;
					sol = i;
					while(!(state & 1) && !is_top_state()) pop_state(i);
					continue;
				case '\\':
					if(i < len) {
						ch = txt[i++];
						if(ch == '\n') sol = i;
					}
					continue;
				case '/':
					if(i < len && !(state & 0x226)) {
						ch = txt[i];
						if(ch == '/') {	// comment to end of line
							push_state(4, i-1);
							i = txt.indexOf('\n', i+1);
							if(i < 0) i = len;
							continue;
						}
						if(ch == '*') {	// extended comment
							push_state(5, i-1);
							++i;
							continue;
						}
					}
					break;
				case '*':
					if(i < len && state == 5 && txt[i] == '/') {	// close ext comment
						pop_state(++i);
						continue;
					}
					break;
				case '[':
					if(state & 0x22) {push_state(0x10,i-1); continue;}
					break;
				case ']':
					if(state & 0x10) {pop_state(i); continue;}
					break;
				case '#':
					if(!state && txt.substr(sol,i-sol-1).match(/^\s*$/)) {
						push_state(8, i-1);
						continue;
					}
					break;
				case '\'':
					if(state == 0x20) {	// close squote
						pop_state(i);
						continue;
					}
					if(!(state & ~0x10)) {	// open squote
						push_state(0x20, i-1);
						continue;
					}
					break;
				case '\"':
					if(state == 2) {	// close string
						pop_state(i);
						continue;
					}
					if(state == 3 && i<len && txt[i]=='}') {	// close ext string
						pop_state(++i);
						continue;
					}
					if(!(state & ~0x10)) {	// open string
						push_state(2, i-1);
						continue;
					}
					break;
				case '{':
					if(!(state & ~0x10) && i<len && txt[i]=='\"') {	// open ext string
						push_state(3, i-1);
						++i;
						continue;
					}
					break;
				case '@':
					if(!(state & ~0x10)) parse_raw_str();
					break;
				default:
					if(!(state & ~0x10)) {
						// check for number
						if(ch>='0' && ch<='9') {
							push_state((use_nums ? 0x80 : state), i-1);
							parse_number();
							pop_state(i);
							continue;
						}
						// check for ident or keyword
						if(ch == '_' || (ch >= 'A' && ch <= 'Z') || (ch >= 'a' && ch <= 'z')) {
							push_state(1, i-1);
							id = parse_id();
							state = id.match(dm_keywords_rx) ? 0x40 : (use_ids ? 0x100 : state);
							pop_state(i);
						}
					}
					break;
			}
		}
		change_state(-1,len);
		return nodes;
	}

	function DM_buildNodes(d,nodes,params) {
		var sp,i,j,k,s,l=nodes.length;
		//for(i=0; i<l; ++i) console.log(nodes[i].state, JSON.stringify(nodes[i].text));
		for(i=0; i<l; ++i) {
			if(!(s=nodes[i].state)) {
				d.appendChild(document.createTextNode(nodes[i].text));
				continue;
			}
			nodes[i].state = null;
			for(k=i,j=i+1; j<l; ++j) {
				if(!nodes[j].state) break;
				if(nodes[j].state == s) {k=j; nodes[j].state=null;}
			}

			sp = document.createElement('span');
			sp.className = 'DM'+s;
			sp.appendChild(document.createTextNode(nodes[i].text));
			if(k>i) {
				if(k>i+1) DM_buildNodes(sp,nodes.slice(i+1,k),params);
				sp.appendChild(document.createTextNode(nodes[k].text));
				i = k;
			}
			d.appendChild(sp);
		}
	}

	function appendNewline(elem) {
		if(elem.nodeType == 3) {elem.textContent += '\n'; return true;}
		if(elem.nodeType != 1) return false;
		var e,l,t;
		for(e=elem.lastChild; e; e=e.previousSibling) {
			if((t=e.nodeType) == 1 || t == 3) return appendNewline(e);
		}
		elem.appendChild(document.createTextNode('\n'));
		return true;
	}

	function newlineBefore(elem) {
		var e;
		for(e=elem.previousSibling; e; e=e.previousSibling) {if(e.appendNewline(elem)) return;}
		elem.parentNode.insertBefore(document.createTextNode('\n'), elem);
	}

	function collapseBr(pre) {
		var i,a=toArray(pre.querySelectorAll('br')),l=a.length;
		for(i=0; i<l; ++i) {
			newlineBefore(a[i]);
			a[i].parentNode.removeChild(a[i]);
		}
	}

	function gettext(pre) {
		collapseBr(pre);
		return pre.textContent;
	}

	var c;
	//var start=now();
	var nodes = DM_nodes(own(params,'text') ? params.text : gettext(pre));
	var after = pre.nextSibling, parent = pre.parentNode;
	parent.removeChild(pre);
	while(c=pre.firstChild) pre.removeChild(c);
	pre = params.output||pre;
	DM_buildNodes(pre,nodes,params);
	parent.insertBefore(pre,after);
	//console.log("Elapsed time for DM highlight: "+(now()-start));
}

function makearticle(p) {
	var d;
	p.appendChild(d=document.createElement('div'));
	d.className = 'article';
	return d;
}

function makeNav(article) {
	var header,name,nav,item,sub,i,a,li;
	name = article.getAttribute('name') || window.help_path;
	if(!name || article.querySelector('.nav') || !(header=article.querySelector('h2'))) return;
	nav = document.createElement('ul');
	nav.className = 'nav';

	for(i=0; i<name.length;) {
		i = name.indexOf('/',i+1);
		if(i<0) i = name.length;
		if(i<0) break;
		sub = name.substr(0,i);
		item = document.querySelector('.article[name="'+sub+'"]');
		if(item) {
			item = item.querySelector('h1,h2');
			item = item.getAttribute('short') || item.textContent;
		}
		else if(window.related_help) item = window.related_help[sub];
		if(item) {
			nav.appendChild(li = document.createElement('li'));
			nav.appendChild(document.createTextNode(' '));
			li.appendChild(a = document.createElement('a'));
			a.href = '#'+sub;
			// change the text to get rid of some extraneous stuff
			item = item.replace(/^.*\((applied to .*)\)$/,'$1');	// turn proc (applied to a matrix) to just "applied to a matrix"
			item = item.replace(/ \(.*\)$/,'');	// get rid of parentheses at end
			item = item.replace(/^(list|matrix)\s+operators$/,'operators');	// change "X operators" to "operators" for certain types
			item = item.replace(/\s+(proc|var|statement|operator|filter|parameter|control|setting)s?$/,'');	// change "key var" to "key"
			item = item.replace(/^(proc|var)s$/,"$1");	// change "procs" to "proc"
			item = item.replace(/ text macro$/,'');
			item = item.replace(/ macro$/,'');
			a.textContent = item;
		}
	}
	article.insertBefore(nav,header.nextSibling);
	header.style.display = 'none';

	if((i=header.getAttribute('byondver'))) {
		item = document.createElement('div');
		item.className='byondver_tag';
		item.textContent = 'Version '+i;
		header.removeAttribute('byondver');
		article.insertBefore(item,header.nextSibling);
	}
	if((i=header.getAttribute('deprecated'))) {
		item = article.querySelector('div.byondver_tag');
		if(!item) {
			item = document.createElement('div');
			item.className='byondver_tag';
		}
		else item.textContent += ', ';
		item.textContent += 'Deprecated';
		item.classList.add('deprecated');
		header.removeAttribute('deprecated');
		article.insertBefore(item,header.nextSibling);
	}
}

function prettify(article) {
	//var start = now();
	var x,n,p,a,i,j,l,dl,d,f,r,lr;
	makeNav(article);
	// style DM code
	while((x=article.querySelector('xmp'))) {
		n = prevElem(x);
		if(n && n.tagName == 'H3') n.classList.add('dmcode');
		p = document.createElement('pre');
		p.className = 'dmcode';
		DMhighlight(x,{output:p});
	}
	// style various subsections in dl tags
	for(a=toArray(article.querySelectorAll('dl')),l=a.length,i=0; i<l; ++i) {
		x = a[i];
		if((p=x.querySelectorAll('dt')).length != 1) continue;
		n = (p = p[0]).textContent.trim();
		if(n == 'Format:') x.classList.add('codedd');
		if(n == 'Args:' || n == 'Possible values:') {
			f = document.createElement('dl');	// just a placeholder
			while((n = x.querySelector('dd'))) {
				x.removeChild(n);
				p = n.innerHTML;
				j = p.indexOf(': ');
				if(j >= 0) {
					if(!dl) {
						dl = document.createElement('dl');
						dl.className = 'codedt';
						d = document.createElement('dd');
						d.appendChild(dl);
						if(f.firstChild) d.classList.add('topspace');
						f.appendChild(d);
					}
					dl.appendChild(d = document.createElement('dt'));
					for(lr=n.attributes,r=0; r<lr.length; ++r) d.setAttribute(lr[r].name,lr[r].value);	// copy attributes
					d.innerHTML = p.substr(0,j).trim().replace(/<\/?b>/g,'');
					dl.appendChild(d = document.createElement('dd'));
					d.innerHTML = p.substr(j+2).trim();
				}
				else {	// happens in cases when the arg list is too generic, like isloc()
					f.appendChild(n);
					dl = null;
				}
			}
			while((d=f.firstChild)) x.appendChild(d);
		}
		if(n == 'See also:') {
			x.classList.add('seealso');
			article.appendChild(x);	// move "See also" to end
		}
	}
	// notes
	a = article.querySelectorAll('p');
	for(i=0,l=a.length; i<l; ++i) {
		if((x=a[i]).textContent.match(/^note:/i)) {
			x.innerHTML = x.innerHTML.replace(/note:\s*/i,'');
			x.classList.add('note');
		}
	}
	// The col tag is limited, so use this to make adjustments
	while(x=article.querySelector('colgroup')) {
		// fill array with applicable cols; assume colgroup is not lying about # of columns
		for(i=0,a=x.querySelectorAll('col'),l=a.length,d=[]; i<l; ++i) {
			n = a[i];	// col element
			j = n.getAttribute('span') || 1;
			while(j-- > 0) d.push(n);
		}
		p = x.parentNode;
		p.removeChild(x);
		lr = [];
		for(i=j=r=0,a=p.querySelectorAll('tr,th,td'),l=a.length; i<l; ++i) {
			x = a[i];
			if(x.tagName == 'TR') {j=0; ++r; continue;}
			while(lr[j]) {	// look out for for previous columns with rowspan
				f = lr[j].cell.rowSpan;
				if(r >= lr[j].row+f) break;
				j += lr[j].cell.colSpan;
			}
			// apply col styles
			if((n=d[j])) {
				if(n.className) x.className += ' '+n.className;
				if(n.getAttribute('style')) x.setAttribute('style',n.style.cssText+x.style.cssText);
			}
			// keep track of this cell in old rows, if need be
			p = x.rowSpan>1 ? {row:r, cell:x} : null;
			for(n=x.colSpan;n--;) lr[j++] = p;
		}
	}
	// handle other version tags
	for(a=article.querySelectorAll('[byondver]'),i=0,l=a.length; i<l; ++i) {
		x = a[i];
		n = document.createElement('span');
		n.className = 'byondver_tag';
		n.textContent = x.getAttribute('byondver');
		x.removeAttribute('byondver');
		x.appendChild(document.createTextNode(' '));
		x.appendChild(n);
	}
	for(a=article.querySelectorAll('[deprecated]'),i=0,l=a.length; i<l; ++i) {
		x = a[i];
		n = x.querySelector('byondver_tag');
		if(!n) {
			n = document.createElement('span');
			n.className = 'byondver_tag';
		}
		else n.textContent += ', ';
		n.textContent += 'Deprecated';
		n.classList.add('deprecated');
		x.removeAttribute('deprecated');
		x.appendChild(document.createTextNode(' '));
		x.appendChild(n);
	}
	// activate any special canvases
	for(a=article.querySelectorAll('canvas[onarticle]'),i=0,l=a.length; i<l; ++i) {
		eval(a[i].getAttribute('onarticle'));
	}
	//console.log("Prettify elapsed time "+(now()-start));
}

function addCSSRule(sheet, selector, rules, index) {
	if("insertRule" in sheet) sheet.insertRule(selector+"{"+rules+"}", index);	// standard
	else if("addRule" in sheet) sheet.addRule(selector, rules, index);	// IE
}

function collapse() {
	if(!window.parent || window.parent==window) {
		document.body.classList.remove('collapsing');
		if(document.body.className=='refpage') prettify(document.body);
		return;
	}
	var ds0=(document.stylesheets||document.styleSheets)[0];
	addCSSRule(ds0, ".refbody > *", "width: 1px; height: 1px; overflow: auto; position: absolute; left: -100px; top: -100px;", 0);
	addCSSRule(ds0, ".refbody > .open", "width: auto; height: auto; display: block; position: relative; left: 0; top: 0;", 0);

	var f=document.createDocumentFragment();
	var b,b2,d,i,j,e,n;
	f.appendChild(b=document.getElementById('refbody'));
	f.appendChild(b2=document.createElement('div'));
	b2.className='refbody';
	e=b.firstChild;
	for(e=b.firstChild,d=makearticle(b2); e; e=n) {
		n = e.nextSibling;
		b.removeChild(e);
		if(e.tagName == 'HR') {
			d=makearticle(b2);
			continue;
		}
		if(e.tagName == 'A' && (i=e.getAttribute('name'))) {
			d.setAttribute('name', i);
			if((i=e.getAttribute('byondver'))) d.setAttribute('byondver',i);
			while((i=e.lastChild)) {
				b.insertBefore(i,n);
				n = i;
			}
		}
		else d.appendChild(e);
	}
	while((e=b2.querySelector('.article:not([name])'))) b2.removeChild(e);	// remove articles without names
	while((e=b2.querySelector('a[name]'))) {	// delete stray named anchors that occur as artifacts
		n = e.parentNode;
		while(i=e.firstChild) n.insertBefore(i,e);
		n.removeChild(e);
	}
	document.body.appendChild(b2);

	document.body.classList.remove('collapsing');

	// Chrome is a piece of crap; it doesn't select Find results, so this hacky workaround is needed
	document.body.addEventListener('scroll',function(e){
		if(e.target.classList.contains('article') && !e.target.classList.contains('open') && document.getSelection().isCollapsed) {
			try {history.replaceState(null,"",'#' + e.target.getAttribute('name'));}
			catch(_) {
				try {document.location.replace('#' + e.target.getAttribute('name'));}
				catch(_) {document.location.hash = '#' + e.target.getAttribute('name');}
			}
			hashpoll();
		}
	}, true);

	var oldhash;
	var activearticle;
	var hashpoll = function() {
		var h=unescape((document.location.hash||'#').substr(1)),x,p;
		var sel, ranges, r, ri, i, s, e;
		if(h != oldhash) {
			oldhash = h;
			if(activearticle) activearticle.classList.remove('open');
			activearticle = document.querySelector('.article[name="'+h+'"]');
			while(!activearticle && h.indexOf('/')>=0) {	// go up the hierarchy if there is no matching article
				h = h.substr(0, h.lastIndexOf('/'));
				activearticle = document.querySelector('.article[name="'+h+'"]');
			}
			if(activearticle) {
				prettify(activearticle);
				activearticle.classList.add('open');
				if((window.parent||window) != window) window.parent.postMessage("nav:"+h,'*');
				document.documentElement.scrollTop = document.body.scrollTop = 0;
			}
		}

		// This selection code works in actual real browsers
		try {
			var sel = document.getSelection();
			if(sel && !sel.isCollapsed) {
				oldranges = null;
				var node = sel.anchorNode;
				for(node=sel.anchorNode; node && node!=document.body; node=node.parentNode) {
					if(node.classList && node.classList.contains('article')) break;
				}
				if(node && node != document.body && node != activearticle) {
					// save selection
					for(i=0,ranges=[]; i<sel.rangeCount; ++i) {
						r = sel.getRangeAt(i);
						if(!r || r.collapsed) continue;
						s = lenfrom(r.startContainer,node,r.startOffset);
						e = lenfrom(r.endContainer,node,r.endOffset);
						ranges.push({s:s,e:e});
					}
					try {history.replaceState(null,"",'#'+(h=node.getAttribute('name')));}
					catch(_) {
						try {document.location.replace('#'+(h=node.getAttribute('name')));}
						catch(_) {document.location.hash = '#'+(h=node.getAttribute('name'));}
					}
					if(activearticle) activearticle.classList.remove('open');
					activearticle = node;
					prettify(activearticle);
					activearticle.classList.add('open');
					if((window.parent||window) != window) window.parent.postMessage("nav:"+h,'*');
					// restore selection after navigation
					sel.removeAllRanges();
					for(i=0; i<ranges.length; ++i) {
						ri=ranges[i];
						s = lento(ri.s,node);
						e = lento(ri.e,node);
						if(s && e) {
							r = document.createRange();
							r.setStart(s[0],s[1]);
							r.setEnd(e[0],e[1]);
							sel.addRange(r);
						}
					}
					showsel();
				}
			}
		} catch(_) {console.log(_);}
	}

	function showsel() {
		var sel = document.getSelection();
		if(!sel.rangeCount) return;
		var rect = sel.getRangeAt(0).getBoundingClientRect();
		var h = document.documentElement.clientHeight;
		if(rect.bottom > h) document.documentElement.scrollTop += rect.bottom-h;
	}

	setInterval(hashpoll, 100);
}

function search(pattern, params) {
	var a=document.querySelectorAll('.article'),h,i,l,t,m,ret={},tp,pl,r;
	if(!params) params = {};
	pattern = pattern.trim();
	if(!pattern) return ret;
	if(!params.regex) {pl=pattern.length; pattern = pattern.replace(/[\\.*+?{}()[\]|^$]/g, "\\$&");}
	else pl=1;
	tp = new RegExp(pattern, params.caseSensitive?'':'i');
	pattern = new RegExp(pattern, params.caseSensitive?'g':'ig');
	for(i=0,l=a.length; i<l; ++i) {
		t = a[i].innerText;
		if((m=t.match(pattern))) {
			h = a[i].querySelector('h2');
			if(!h) continue;
			// Relevance is roughly pattern length / article length, raised to 1/N power where N = # of matches
			r = Math.pow((pl-0.0)/t.length, 1.0/m.length);
			if((m=h.innerText.match(tp))) {
				r += 1.0;	// title match adds a lot to relevance
				if(!m.index) {
					r += 1.0;	// title match beginning with pattern adds even more relevance
					if(m[0].length+m.index == h.innerText.length) r += 1.0;	// full match is best of all
				}
			}
			// TODO: find a way to get a good excerpt out of the article, excluding title, see-also, and xmp/pre blocks
			ret[a[i].getAttribute('name')] = {relevance:r, name:h.textContent};
		}
	}
	return ret;
}

function lenfrom(node,parent,offset) {
	var n,len=0;
	if(offset) len=offset;
	if(node.nodeType==Node.TEXT_NODE) len = textlen(node,len);	// trim xmp
	while(node && node != parent) {
		while((n=node.previousSibling)) len += textlen(node=n);
		node = node.parentNode;
	}
	return len;
}

function lento(len,parent) {
	var node,n,l;
	node = parent;
	while(len>0) {
		while(node.nodeType==Node.ELEMENT_NODE && (n=node.firstChild)) node=n;
		if(node.nodeType==Node.TEXT_NODE) {
			l = node.textContent.length;
			if(l>=len) return [node,textlen(node,len)];	// trim xmp
			len -= l;
		}
		while(node!=parent) {
			if((n=node.nextSibling)) {node=n; break;}
			node = node.parentNode;
		}
		if(node==parent) break;
	}
	return null;
}

function textlen(node,limit) {
	var t,adj,c,len,tab;
	if(node.nodeType==Node.TEXT_NODE) {
		t = node.textContent;
		adj = 0;
		if(typeof limit == 'number' && limit <= t.length) {t = t.substr(0,limit)+String.fromCharCode(0xFFFF); adj=1;}
		if(!(c=node.parentNode) || c.nodeType!=Node.ELEMENT_NODE || c.tagName!='XMP') return t.length-adj;
		t = t.replace(/\r/g,'');
		// trim lines
		t = t.replace(/^(\s*\n)*/g, '');
		t = t.replace(/[\s\n]*$/g, '');
		// tabs to spaces (default 4 spaces)
		while(t.indexOf('\t\t') >= 0) t = t.replace(/(\t+)\t/g,'$1    ');
		while(t.indexOf('\n\t') >= 0) t = t.replace(/\n\t/g,'\n    ');
		while((c=t.indexOf('\t')) >= 0) {
			len = t.lastIndexOf('\n',c)+1;
			for(tab=" "; (c-len+tab.length) % 4; tab+=" ");
			t = t.substr(0,c)+tab+t.substr(c+1);
		}
		return t.length-adj;
	}
	if(node.nodeType==Node.ELEMENT_NODE) {
		for(len=0,c=node.firstChild; c; c=c.nextSibling) len += textlen(c);
		return len;
	}
	return 0;
}

function contentLoaded(win, fn) {
	var done = false, top = true,
	doc = win.document,
	root = doc.documentElement,
	modern = doc.addEventListener,
	add = modern ? 'addEventListener' : 'attachEvent',
	rem = modern ? 'removeEventListener' : 'detachEvent',
	pre = modern ? '' : 'on',
	init = function(e) {
		if (e.type == 'readystatechange' && doc.readyState != 'complete') return;
		(e.type == 'load' ? win : doc)[rem](pre + e.type, init, false);
		if (!done && (done = true)) fn.call(win, e.type || e);
	},
	poll = function() {
		try { root.doScroll('left'); } catch(e) { setTimeout(poll, 50); return; }
		init('poll');
	};
	if (doc.readyState == 'complete') fn.call(win, 'lazy');
	else {
		if (!modern && root.doScroll) {
			try { top = !win.frameElement; } catch(e) { }
			if (top) poll();
		}
		doc[add](pre + 'DOMContentLoaded', init, false);
		doc[add](pre + 'readystatechange', init, false);
		win[add](pre + 'load', init, false);
	}
}
contentLoaded(window,collapse);
