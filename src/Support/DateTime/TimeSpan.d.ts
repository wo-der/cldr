import { TimeSpanFormatInfo } from "./TimeSpanFormatInfo";

interface TimeSpan {
	TotalDays: number;
	TotalHours: number;
	TotalMinutes: number;
	TotalSeconds: number;
	TotalMilliseconds: number;
	Days: number;
	Hours: number;
	Minutes: number;
	Seconds: number;
	Milliseconds: number;

	Format(format: string, tsfi?: TimeSpanFormatInfo): string;
}

interface TimeSpanConstructor {
	new (days?: number, hours?: number, minutes?: number, seconds?: number, millisecond?: number): TimeSpan;

	FromMilliseconds: (value: number) => TimeSpan;
	FromSeconds: (value: number) => TimeSpan;
	FromMinutes: (value: number) => TimeSpan;
	FromHours: (value: number) => TimeSpan;
	FromDays: (value: number) => TimeSpan;
}

export const TimeSpan: TimeSpanConstructor;
