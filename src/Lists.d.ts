import { Language, Locale, Script, Territory, Variant } from "./Locale";

type ListStyle = "standard" | string;

interface Lists {
	FormatList: <
		L extends Language = Language,
		T extends Territory | string = "",
		S extends Script | string = "",
		V extends Variant | string = "",
	>(
		locale: Locale<L, T, S, V>,
		list: string[],
		style?: ListStyle,
	) => string;

	FormatNumericalList: <
		L extends Language = Language,
		T extends Territory | string = "",
		S extends Script | string = "",
		V extends Variant | string = "",
	>(
		locale: Locale<L, T, S, V>,
		list: number[],
		includeEnd?: boolean,
		format?: string,
		decimalQuantization?: boolean,
	) => string;

	ParseNumericalList: <
		L extends Language = Language,
		T extends Territory | string = "",
		S extends Script | string = "",
		V extends Variant | string = "",
	>(
		locale: Locale<L, T, S, V>,
		str: string,
	) => number[];
}

export const Lists: Lists;
