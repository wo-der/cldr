import { Language, Locale, Script, Territory, Variant } from "./Locale";
import { LocaleData } from "./LocaleData";

interface Texts {
	FormatPluralizedText: <
		L extends Language = Language,
		T extends Territory | string = "",
		S extends Script | string = "",
		V extends Variant | string = "",
	>(
		locale: Locale<L, T, S, V>,
		data: Record<string, string>,
		value: number,
		format?: string,
	) => string;

	FormatText: (text: string, ...args: unknown[]) => string;

	LoadTable: typeof LocaleData.LoadTable;
	LoadFolder: typeof LocaleData.LoadFolder;
}

export const Texts: Texts;
