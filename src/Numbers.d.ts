import { Language, Locale, Script, Territory, Variant } from "./Locale";

interface CurrencyInfo {
	displayName: { [key: string]: string }; // 지역별 통화 이름 (예: "US Dollar", "Euro")
	symbol: {
		symbol: string; // 기본 통화 기호 (예: "$", "€")
		narrow?: string; // 좁은 형태의 기호 (예: "US$" → "$")
		international?: string; // 국제 표기법 (예: "USD", "EUR")
		ISO?: string; // ISO 4217 코드 (예: "USD", "EUR", "KRW")
	};
	currencyFormat?: number | string; // 통화 형식 (예: 1 → 소수점 없이, 2 → 소수점 2자리)
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
		F extends "standard" | "accounting" | "short" = "standard",
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
		F extends "standard" | "accounting" | "short" = "standard",
	>(
		locale: Locale<L, T, S, V>,
		value: number | string,
		format?: F,
		decimalPlaces?: Array<number> | number,
		ignoreMinimumGroupingDigit?: boolean,
	) => string;
	FormatCompactCurrency: <
		L extends Language = Language,
		T extends Territory | string = "",
		S extends Script | string = "",
		V extends Variant | string = "",
		F extends "standard" | "accounting" | "short" = "standard",
	>(
		locale: Locale<L, T, S, V>,
		value: number | string,
		currency?: CurrencyInfo,
		currencyDigits?: boolean,
		format?: F,
		decimalPlaces?: Array<number> | number,
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
