import { Language, Locale, Script, Territory, Variant } from "./Locale";

type DateTimeFormat = "full" | "long" | "medium" | "short";
type DurationFormat = "long" | "short" | "narrow";
type DurationGranularity = "year" | "month" | "week" | "day" | "hour" | "minute" | "second" | "millisecond";

interface DateTime {
	Year: number;
	Month: number;
	Day: number;
	Hour: number;
	Minute: number;
	Second: number;
	Weekday: number;
	TimeOfDay: { TotalSeconds: number };
}

interface TimeSpan {
	TotalMilliseconds: number;
}

interface Dates {
	FormatDateTime: <
		L extends Language = Language,
		T extends Territory | string = "",
		S extends Script | string = "",
		V extends Variant | string = "",
	>(
		locale: Locale<L, T, S, V>,
		dt: DateTime,
		format?: DateTimeFormat,
	) => string;

	FormatDate: <
		L extends Language = Language,
		T extends Territory | string = "",
		S extends Script | string = "",
		V extends Variant | string = "",
	>(
		locale: Locale<L, T, S, V>,
		dt: DateTime,
		format?: DateTimeFormat,
	) => string;

	FormatTime: <
		L extends Language = Language,
		T extends Territory | string = "",
		S extends Script | string = "",
		V extends Variant | string = "",
	>(
		locale: Locale<L, T, S, V>,
		dt: DateTime,
		format?: DateTimeFormat,
	) => string;

	FormatTimeSpan: <
		L extends Language = Language,
		T extends Territory | string = "",
		S extends Script | string = "",
		V extends Variant | string = "",
	>(
		locale: Locale<L, T, S, V>,
		ts: TimeSpan,
		granularity?: DurationGranularity,
		threshold?: number,
		addDirection?: boolean,
		format?: DurationFormat,
	) => string;

	FormatFlexible: <
		L extends Language = Language,
		T extends Territory | string = "",
		S extends Script | string = "",
		V extends Variant | string = "",
	>(
		locale: Locale<L, T, S, V>,
		dt: DateTime,
		format: string,
	) => string;

	FormatInterval: <
		L extends Language = Language,
		T extends Territory | string = "",
		S extends Script | string = "",
		V extends Variant | string = "",
	>(
		locale: Locale<L, T, S, V>,
		start: DateTime,
		end: DateTime,
		format?: string,
	) => string;

	ParseDateTime: <
		L extends Language = Language,
		T extends Territory | string = "",
		S extends Script | string = "",
		V extends Variant | string = "",
	>(
		locale: Locale<L, T, S, V>,
		str: string,
		format?: string,
		strict?: boolean,
	) => DateTime;
}

export const Dates: Dates;
