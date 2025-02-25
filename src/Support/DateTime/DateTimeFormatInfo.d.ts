export type DayOfWeek = "Monday" | "Tuesday" | "Wednesday" | "Thursday" | "Friday" | "Saturday" | "Sunday";

interface DateTimeFormatInfo {
	ReadOnly: boolean;

	StandaloneMonthNames: string[];
	StandaloneDayNames: string[];
	MonthNames: string[];
	DayNames: string[];

	AbbreviatedStandaloneMonthNames: string[];
	AbbreviatedStandaloneDayNames: string[];
	AbbreviatedMonthNames: string[];
	AbbreviatedDayNames: string[];

	AMDesignator: string;
	PMDesignator: string;

	DateSeparator: string;
	TimeSeparator: string;

	ShortDatePattern: string;
	LongDatePattern: string;
	ShortTimePattern: string;
	LongTimePattern: string;
	FullDateTimePattern: string;
	MonthDayPattern: string;
	YearMonthPattern: string;

	FirstDayOfWeek: number;

	Clone(): DateTimeFormatInfo;
}

interface DateTimeFormatInfoConstructor {
	new (options?: Partial<DateTimeFormatInfo>): DateTimeFormatInfo;

	Preset: {
		da: DateTimeFormatInfo;
		de: DateTimeFormatInfo;
		en: DateTimeFormatInfo;
		en_001: DateTimeFormatInfo;
		es: DateTimeFormatInfo;
		es_419: DateTimeFormatInfo;
		fr: DateTimeFormatInfo;
		ja: DateTimeFormatInfo;
	};

	EnumDayOfWeek: {
		Monday: number;
		Tuesday: number;
		Wednesday: number;
		Thursday: number;
		Friday: number;
		Saturday: number;
		Sunday: number;
	};
}

export const DateTimeFormatInfo: DateTimeFormatInfoConstructor;
