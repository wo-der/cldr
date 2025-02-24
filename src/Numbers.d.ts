import { Language, Locale, Script, Territory, Variant } from "./Locale";

type PluralCategory = "zero" | "one" | "two" | "few" | "many" | "other";
type CurrencyFormat = "standard" | "accounting" | "short";

interface CurrencyInfo {
	displayName: Partial<Record<PluralCategory, string>>;
	symbol: {
		symbol: string;
		narrow?: string;
		international?: string;
		ISO?: string;
	};
	currencyFormat?: number | string;
}

interface Numbers {
	FormatCustom: <
		L extends Language = Language,
		T extends Territory | string = "",
		S extends Script | string = "",
		V extends Variant | string = "",
	>(
		locale: Locale<L, T, S, V>,
		format: string,
		value: number | string,
		decimalQuantization?: boolean,
		ignoreMinimumGroupingDigit?: boolean,
	) => string;

	FormatDecimal: <
		L extends Language = Language,
		T extends Territory | string = "",
		S extends Script | string = "",
		V extends Variant | string = "",
	>(
		locale: Locale<L, T, S, V>,
		value: number | string,
		decimalQuantization?: boolean,
		ignoreMinimumGroupingDigit?: boolean,
	) => string;

	FormatScientific: <
		L extends Language = Language,
		T extends Territory | string = "",
		S extends Script | string = "",
		V extends Variant | string = "",
	>(
		locale: Locale<L, T, S, V>,
		value: number | string,
		decimalQuantization?: boolean,
		ignoreMinimumGroupingDigit?: boolean,
	) => string;

	FormatPercent: <
		L extends Language = Language,
		T extends Territory | string = "",
		S extends Script | string = "",
		V extends Variant | string = "",
	>(
		locale: Locale<L, T, S, V>,
		value: number | string,
		decimalQuantization?: boolean,
		ignoreMinimumGroupingDigit?: boolean,
	) => string;

	FormatCurrency: <
		L extends Language = Language,
		T extends Territory | string = "",
		S extends Script | string = "",
		V extends Variant | string = "",
		F extends CurrencyFormat = "standard",
	>(
		locale: Locale<L, T, S, V>,
		value: number | string,
		currency?: CurrencyInfo,
		format?: F,
		currencyDigits?: boolean,
		decimalQuantization?: boolean,
		ignoreMinimumGroupingDigit?: boolean,
	) => string;

	FormatCompactDecimal: <
		L extends Language = Language,
		T extends Territory | string = "",
		S extends Script | string = "",
		V extends Variant | string = "",
		F extends CurrencyFormat = "standard",
	>(
		locale: Locale<L, T, S, V>,
		value: number | string,
		format?: F,
		decimalPlaces?: number[] | number,
		ignoreMinimumGroupingDigit?: boolean,
	) => string;

	FormatCompactCurrency: <
		L extends Language = Language,
		T extends Territory | string = "",
		S extends Script | string = "",
		V extends Variant | string = "",
		F extends CurrencyFormat = "standard",
	>(
		locale: Locale<L, T, S, V>,
		value: number | string,
		currency?: CurrencyInfo,
		currencyDigits?: boolean,
		format?: F,
		decimalPlaces?: number[] | number,
		ignoreMinimumGroupingDigit?: boolean,
	) => string;

	ParseFloat: <
		L extends Language = Language,
		T extends Territory | string = "",
		S extends Script | string = "",
		V extends Variant | string = "",
	>(
		locale: Locale<L, T, S, V>,
		str: string,
		strict?: boolean,
	) => number;

	ParseDecimal: <
		L extends Language = Language,
		T extends Territory | string = "",
		S extends Script | string = "",
		V extends Variant | string = "",
	>(
		locale: Locale<L, T, S, V>,
		str: string,
		strict?: boolean,
	) => number;
}

export const Numbers: Numbers;
