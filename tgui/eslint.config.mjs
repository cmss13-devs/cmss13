import { defineConfig, globalIgnores } from 'eslint/config';
import react from 'eslint-plugin-react';
import unusedImports from 'eslint-plugin-unused-imports';
import simpleImportSort from 'eslint-plugin-simple-import-sort';
import typescriptEslint from '@typescript-eslint/eslint-plugin';
import globals from 'globals';
import tsParser from '@typescript-eslint/parser';
import prettier from 'eslint-config-prettier/flat';

export default defineConfig([
  globalIgnores([
    '.yarn/**/*',
    '**/node_modules',
    '**/*.bundle.*',
    '**/*.chunk.*',
    '**/*.hot-update.*',
    '**/**.lock',
    '**/**.log',
    '**/**.json',
    '**/**.svg',
    '**/**.scss',
    '**/**.md',
    '**/**.css',
    '**/**.txt',
    '**/**.woff2',
    '**/**.eot',
    '**/**.ttf',
  ]),
  prettier,
  {
    plugins: {
      react,
      'unused-imports': unusedImports,
      'simple-import-sort': simpleImportSort,
      '@typescript-eslint': typescriptEslint,
    },

    languageOptions: {
      globals: {
        ...globals.browser,
        ...globals.node,
      },

      parser: tsParser,
      ecmaVersion: 2020,
      sourceType: 'module',

      parserOptions: {
        ecmaFeatures: {
          jsx: true,
        },
      },
    },

    settings: {
      react: {
        version: '18.2',
      },
    },

    rules: {
      'no-async-promise-executor': 'error',
      'no-cond-assign': 'error',
      'no-debugger': 'error',
      'no-dupe-args': 'error',
      'no-dupe-keys': 'error',
      'no-duplicate-case': 'error',
      'no-empty-character-class': 'error',
      'no-ex-assign': 'error',
      'no-extra-boolean-cast': 'error',
      'no-extra-semi': 'error',
      'no-func-assign': 'error',
      'no-import-assign': 'error',
      'no-inner-declarations': 'error',
      'no-invalid-regexp': 'error',
      'no-irregular-whitespace': 'error',
      'no-misleading-character-class': 'error',
      'no-obj-calls': 'error',
      'no-prototype-builtins': 'error',
      'no-regex-spaces': 'error',
      'no-sparse-arrays': 'error',
      'no-template-curly-in-string': 'error',
      'no-unexpected-multiline': 'error',
      'no-unsafe-finally': 'error',
      'no-unsafe-negation': 'error',
      'use-isnan': 'error',
      'valid-typeof': 'error',

      complexity: [
        'error',
        {
          max: 50,
        },
      ],

      curly: ['error', 'multi-line'],
      'dot-location': ['error', 'property'],
      eqeqeq: ['error', 'always'],
      'no-case-declarations': 'error',
      'no-empty-pattern': 'error',
      'no-fallthrough': 'error',
      'no-global-assign': 'error',
      'no-multi-spaces': 'warn',
      'no-octal': 'error',
      'no-octal-escape': 'error',
      'no-redeclare': 'error',
      'no-return-assign': 'error',
      'no-self-assign': 'error',
      'no-sequences': 'error',
      'no-unused-labels': 'warn',
      'no-useless-escape': 'warn',
      'no-with': 'error',
      radix: 'error',
      strict: 'error',
      'no-delete-var': 'error',
      'no-shadow-restricted-names': 'error',
      'no-undef-init': 'error',
      'array-bracket-newline': ['error', 'consistent'],
      'array-bracket-spacing': ['error', 'never'],
      'block-spacing': ['error', 'always'],

      'comma-dangle': [
        'error',
        {
          arrays: 'always-multiline',
          objects: 'always-multiline',
          imports: 'always-multiline',
          exports: 'always-multiline',
          functions: 'only-multiline',
        },
      ],

      'comma-spacing': [
        'error',
        {
          before: false,
          after: true,
        },
      ],

      'comma-style': ['error', 'last'],
      'computed-property-spacing': ['error', 'never'],
      'object-curly-spacing': ['error', 'always'],
      semi: 'error',

      'semi-spacing': [
        'error',
        {
          before: false,
          after: true,
        },
      ],

      'semi-style': ['error', 'last'],
      'space-before-blocks': ['error', 'always'],
      'space-in-parens': ['error', 'never'],
      'spaced-comment': ['error', 'always'],

      'switch-colon-spacing': [
        'error',
        {
          before: false,
          after: true,
        },
      ],

      'template-tag-spacing': ['error', 'never'],

      'arrow-spacing': [
        'error',
        {
          before: true,
          after: true,
        },
      ],

      'generator-star-spacing': [
        'error',
        {
          before: false,
          after: true,
        },
      ],

      'no-class-assign': 'error',
      'no-const-assign': 'error',
      'no-dupe-class-members': 'error',
      'no-new-symbol': 'error',
      'no-this-before-super': 'error',
      'no-var': 'error',
      'prefer-arrow-callback': 'error',

      'yield-star-spacing': [
        'error',
        {
          before: false,
          after: true,
        },
      ],

      'react/boolean-prop-naming': 'error',
      'react/button-has-type': 'error',
      'react/default-props-match-prop-types': 'error',
      'react/no-access-state-in-setstate': 'error',
      'react/no-children-prop': 'error',
      'react/no-danger': 'error',
      'react/no-danger-with-children': 'error',
      'react/no-deprecated': 'error',
      'react/no-did-mount-set-state': 'error',
      'react/no-did-update-set-state': 'error',
      'react/no-direct-mutation-state': 'error',
      'react/no-find-dom-node': 'error',
      'react/no-is-mounted': 'error',
      'react/no-redundant-should-component-update': 'error',
      'react/no-render-return-value': 'error',
      'react/no-typos': 'error',
      'react/no-string-refs': 'error',
      'react/no-this-in-sfc': 'error',
      'react/no-unescaped-entities': 'error',
      'react/no-unsafe': 'error',
      'react/no-unused-prop-types': 'error',
      'react/no-unused-state': 'error',
      'react/no-will-update-set-state': 'error',
      'react/prefer-es6-class': 'error',
      'react/prefer-read-only-props': 'error',
      'react/prefer-stateless-function': 'error',
      'react/require-render-return': 'error',
      'react/self-closing-comp': 'error',
      'react/style-prop-object': 'error',
      'react/void-dom-elements-no-children': 'error',
      'react/jsx-boolean-value': 'error',
      'react/jsx-closing-tag-location': 'error',
      'react/jsx-curly-spacing': 'error',
      'react/jsx-equals-spacing': 'error',
      'react/jsx-handler-names': 'error',
      'react/jsx-key': 'error',

      'react/jsx-max-depth': [
        'error',
        {
          max: 10,
        },
      ],

      'react/jsx-no-comment-textnodes': 'error',
      'react/jsx-no-duplicate-props': 'error',
      'react/jsx-no-target-blank': 'error',
      'react/jsx-no-undef': 'error',
      'react/jsx-no-useless-fragment': 'error',
      'react/jsx-fragments': 'error',
      'react/jsx-pascal-case': 'error',
      'react/jsx-props-no-multi-spaces': 'error',
      'react/jsx-tag-spacing': 'error',
      'react/jsx-uses-react': 'error',
      'react/jsx-uses-vars': 'error',
      'react/jsx-wrap-multilines': 'error',
      'unused-imports/no-unused-imports': 'error',
      'simple-import-sort/imports': 'error',
      'simple-import-sort/exports': 'error',

      '@typescript-eslint/consistent-type-imports': [
        'error',
        {
          fixStyle: 'inline-type-imports',
        },
      ],
    },
  },
]);
