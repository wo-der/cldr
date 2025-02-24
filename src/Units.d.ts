import { Language, Locale, Script, Territory, Variant } from "./Locale";
type UnitLength = "long" | "short" | "narrow";

interface Units {
	FormatUnit: <
		L extends Language = Language,
		T extends Territory | string = "",
		S extends Script | string = "",
		V extends Variant | string = "",
	>(
		locale: Locale<L, T, S, V>,
		value: number,
		measurementUnit: string,
		length?: UnitLength,
		format?: string,
	) => string;

	FormatCompoundUnit: <
		L extends Language = Language,
		T extends Territory | string = "",
		S extends Script | string = "",
		V extends Variant | string = "",
	>(
		locale: Locale<L, T, S, V>,
		numeratorValue: number,
		numeratorUnit: string,
		denominatorValue: number,
		denominatorUnit: string,
		length?: UnitLength,
		format?: string,
	) => string;
}

export const Units: Units;
