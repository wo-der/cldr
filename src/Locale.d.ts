export type Language =
	| "af"
	| "am"
	| "ar"
	| "az"
	| "be"
	| "bg"
	| "bn"
	| "bs"
	| "ca"
	| "cs"
	| "da"
	| "de"
	| "el"
	| "en"
	| "es"
	| "et"
	| "eu"
	| "fa"
	| "fi"
	| "fil"
	| "fr"
	| "gl"
	| "gu"
	| "hi"
	| "hr"
	| "hu"
	| "hy"
	| "id"
	| "is"
	| "it"
	| "iw"
	| "ja"
	| "ka"
	| "kk"
	| "km"
	| "kn"
	| "ko"
	| "ky"
	| "lo"
	| "lt"
	| "lv"
	| "mk"
	| "ml"
	| "mn"
	| "mr"
	| "ms"
	| "my"
	| "nb"
	| "ne"
	| "nl"
	| "pa"
	| "pl"
	| "pt"
	| "ro"
	| "root"
	| "ru"
	| "si"
	| "sk"
	| "sl"
	| "sq"
	| "sr"
	| "sv"
	| "sw"
	| "ta"
	| "te"
	| "th"
	| "tr"
	| "uk"
	| "ur"
	| "uz"
	| "vi"
	| "zh"
	| "zu";
export type Territory =
	| "001"
	| "419"
	| "AL"
	| "AM"
	| "AZ"
	| "BA"
	| "BD"
	| "BG"
	| "BR"
	| "BY"
	| "CA"
	| "CN"
	| "CZ"
	| "DE"
	| "DK"
	| "EE"
	| "ES"
	| "ET"
	| "FI"
	| "FR"
	| "GB"
	| "GE"
	| "GR"
	| "HK"
	| "HR"
	| "HU"
	| "ID"
	| "IL"
	| "IN"
	| "IR"
	| "IS"
	| "IT"
	| "JP"
	| "KG"
	| "KH"
	| "KR"
	| "KZ"
	| "LA"
	| "LK"
	| "LT"
	| "LV"
	| "MK"
	| "MM"
	| "MN"
	| "MX"
	| "MY"
	| "NL"
	| "NO"
	| "NP"
	| "PH"
	| "PK"
	| "PL"
	| "PT"
	| "RO"
	| "RS"
	| "RU"
	| "SE"
	| "SI"
	| "SK"
	| "TH"
	| "TR"
	| "TW"
	| "TZ"
	| "UA"
	| "US"
	| "UZ"
	| "VN"
	| "ZA";
export type Script = "Hans" | "Hant" | "Latn";
export type Variant = "POSIX" | "EURO" | "VALENCIA" | "1901" | "1996";

interface NumberSymbols {
	decimal: string;
	group: string;
	list: string;
	percentSign: string;
	plusSign: string;
	minusSign: string;
	exponential: string;
	superscriptingExponent: string;
	perMille: string;
	infinity: string;
	nan: string;
}

interface DecimalFormat {
	format: string;
	long: Record<number, { one: string; other: string }>;
	short: Record<number, { one: string; other: string }>;
}

interface PercentFormat {
	format: string;
}

interface ScientificFormat {
	format: string;
}

interface CurrencyFormat {
	format: {
		standard: string;
		accounting: string;
	};
	short: Record<number, { one: string; other: string }>;
}

interface LatnNumbers {
	symbols: NumberSymbols;
	decimalFormats: DecimalFormat;
	percentFormats: PercentFormat;
	scientificFormats: ScientificFormat;
	currencyFormats: CurrencyFormat;
}

interface PluralForm {
	one: string;
}

interface OrdinalForm {
	few: string;
	one: string;
	two: string;
}

interface LocaleNumbers {
	latn: LatnNumbers;
	pluralForm: PluralForm;
	ordinalForm: OrdinalForm;
}

export class Locale<
	L extends Language = Language,
	T extends Territory | string = "",
	S extends Script | string = "",
	V extends Variant | string = "",
> {
	/** The language code (e.g., "en" for English, "ko" for South Korea). */
	public readonly language: L;
	/** The territory or region code (e.g., "US" for United States, "KR" for South Korea). */
	public readonly territory: T;
	/** The script type (e.g., "Hans" for Simplified Chinese, "Latn" for Latin script). */
	public readonly script: S;
	/** The variant type (e.g., "POSIX" for POSIX compatibility). */
	public readonly variant: V;
	public readonly numbers: LocaleNumbers;

	/**
	 * Creates a new `Locale` instance.
	 * @example
	 * const locale = new Locale("en", "US");
	 * print(locale.language); // "en";
	 * @example
	 * const locale = new Locale("zh", "CN", "Hans");
	 * print(locale.script); // "Hans"
	 */
	public constructor(language: L, territory?: T, script?: S, variant?: V);

	/**
	 * Parses a locale identifier string and returns a `Locale` instance.
	 * @example
	 * const locale = Locale.Parse("ko_KR");
	 * print(locale.language); // "KR"
	 */
	public static Parse: <Sep extends string = "_">(
		identifier: string,
		separator?: Sep,
	) => Locale<Language, Territory, Script, Variant>;

	/**
	 * Converts a locale tuple into a locale identifier string.
	 * @example
	 * const id = Locale.ToLocaleIdentifier(["zh", "CN", "Hans"]);
	 * print(id); // "zh_CN_Hans"
	 */
	public static ToLocaleIdentifier: <
		L extends Language,
		T extends Territory | undefined = undefined,
		S extends Script | undefined = undefined,
		V extends Variant | undefined = undefined,
		Sep extends string = "_",
	>(
		tuple: [L, T?, S?, V?],
		separator?: Sep,
	) => T extends undefined
		? `${L}`
		: S extends undefined
			? `${L}${Sep}${T}`
			: V extends undefined
				? `${L}${Sep}${T}${Sep}${S}`
				: `${L}${Sep}${T}${Sep}${S}${Sep}${V}`;

	/**
	 * Retrieves the Roblox system's default locale.
	 * @example
	 * const locale = Locale.RobloxLocaleId();
	 */
	public static RobloxLocaleId: () => Locale<Language, Territory, Script, Variant>;

	/**
	 * Retrieves the system locale from Roblox's LocalizationService.
	 * @example
	 * const locale = Locale.SystemLocaleId();
	 */
	public static SystemLocaleId: () => Locale<Language, Territory, Script, Variant>;

	/**
	 * Returns the display name for the locale in a human-readable format.
	 * @example
	 * print(new Locale("en", "US").GetDisplayName());
	 */
	public GetDisplayName<
		L extends Language = Language,
		T extends Territory | string = "",
		S extends Script | string = "",
		V extends Variant | string = "",
	>(locale?: Locale<L, T, S, V>): string;
}
