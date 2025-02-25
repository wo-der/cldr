import { DateTimeFormatInfo } from "./DateTimeFormatInfo";

interface TimeOfDay {
	TotalSeconds: number;
}

interface DateTime {
	Year: number;
	Month: number;
	Day: number;
	Hour: number;
	Minute: number;
	Second: number;
	Millisecond: number;
	Weekday: number;
	Ordinal: number;
	TimeOfDay: TimeOfDay;

	AddMilliseconds(value: number): DateTime;
	AddSeconds(value: number): DateTime;
	AddMinutes(value: number): DateTime;
	AddHours(value: number): DateTime;
	AddDays(value: number): DateTime;
	AddMonths(value: number): DateTime;
	AddYears(value: number): DateTime;

	ISO8601(sep?: string): string;
	RFC2822(): string;
	ctime(): string;
	Epoch(): number;
	EpochMilliseconds(): number;
	OsDate(): typeof os.date;
	Format(format: string, dtfi?: DateTimeFormatInfo): string;
}

interface DateTimeConstructor {
	new (
		year: number,
		month: number,
		day: number,
		hour?: number,
		minute?: number,
		second?: number,
		millisecond?: number,
	): DateTime;

	FromEpoch: (timestamp: number) => DateTime;
	FromMillisecondsEpoch: (timestamp: number) => DateTime;
	FromISO8601: (format: string) => DateTime;
	FromOsDate: (osdate: typeof os.date) => DateTime;
	Now: () => DateTime;
	MillisecondsNow: () => DateTime;
	UtcNow: () => DateTime;
	UtcMillisecondsNow: () => DateTime;
	Today: () => DateTime;
	DaysInMonth: (year: number, month: number) => number;
	IsLeapYear: (year: number) => boolean;
}

export const DateTime: DateTimeConstructor;
