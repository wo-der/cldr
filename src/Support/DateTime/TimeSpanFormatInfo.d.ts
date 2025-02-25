interface TimeSpanFormatInfo {
	ReadOnly: boolean;

	TimeSeparator: string;
	MillisecondSeparator: string;

	DayHourMinuteSecondPattern: string;
	HourMinuteSecondPattern: string;
	HourMinuteSecondMillisecondPattern: string;
	MinuteSecondPattern: string;
	MinuteSecondMillisecondPattern: string;
	SecondMillisecondPattern: string;

	AbbreviatedDayHourMinuteSecondPattern: string;
	AbbreviatedHourMinuteSecondPattern: string;
	AbbreviatedHourMinuteSecondMillisecondPattern: string;
	AbbreviatedMinuteSecondPattern: string;
	AbbreviatedMinuteSecondMillisecondPattern: string;
	AbbreviatedSecondMillisecondPattern: string;

	FullDayHourMinuteSecondPattern: string;
	FullHourMinuteSecondPattern: string;
	FullHourMinuteSecondMillisecondPattern: string;
	FullMinuteSecondPattern: string;
	FullMinuteSecondMillisecondPattern: string;
	FullSecondMillisecondPattern: string;

	Clone(): TimeSpanFormatInfo;
}

interface TimeSpanFormatInfoConstructor {
	new (options?: Partial<TimeSpanFormatInfo>): TimeSpanFormatInfo;

	Preset: {
		da: TimeSpanFormatInfo;
		de: TimeSpanFormatInfo;
		en: TimeSpanFormatInfo;
		ja: TimeSpanFormatInfo;
	};
}

export const TimeSpanFormatInfo: TimeSpanFormatInfoConstructor;
