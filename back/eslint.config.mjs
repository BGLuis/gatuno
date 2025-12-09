// @ts-check
import eslint from '@eslint/js';
import eslintPluginPrettierRecommended from 'eslint-plugin-prettier/recommended';
import sonarjs from 'eslint-plugin-sonarjs';
import globals from 'globals';
import tseslint from 'typescript-eslint';

export default tseslint.config(
	{
		ignores: [
			'eslint.config.mjs',
			'dist/**',
			'node_modules/**',
			'coverage/**',
		],
	},
	eslint.configs.recommended,
	...tseslint.configs.recommendedTypeChecked,
	sonarjs.configs.recommended,
	eslintPluginPrettierRecommended,
	{
		languageOptions: {
			globals: {
				...globals.node,
				...globals.jest,
			},
			ecmaVersion: 5,
			sourceType: 'module',
			parserOptions: {
				projectService: true,
				tsconfigRootDir: import.meta.dirname,
			},
		},
	},
	{
		rules: {
			// TypeScript rules
			'@typescript-eslint/no-explicit-any': 'off',
			'@typescript-eslint/no-floating-promises': 'warn',
			'@typescript-eslint/no-unsafe-argument': 'warn',

			// SonarJS rules - Code Quality
			'sonarjs/cognitive-complexity': ['warn', 15],
			'sonarjs/no-duplicate-string': ['warn', { threshold: 3 }],
			'sonarjs/no-identical-functions': 'warn',
			'sonarjs/no-collapsible-if': 'warn',
			'sonarjs/prefer-immediate-return': 'warn',
			'sonarjs/no-redundant-jump': 'warn',
			'sonarjs/no-small-switch': 'warn',
			'sonarjs/no-nested-template-literals': 'warn',

			// SonarJS rules - Bug Detection
			'sonarjs/no-all-duplicated-branches': 'error',
			'sonarjs/no-element-overwrite': 'error',
			'sonarjs/no-identical-conditions': 'error',
			'sonarjs/no-identical-expressions': 'error',
			'sonarjs/no-one-iteration-loop': 'error',
			'sonarjs/no-use-of-empty-return-value': 'error',
		},
	},
);
