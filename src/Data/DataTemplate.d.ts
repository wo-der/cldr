interface Identity {
	language: string;
	territory: string;
}

interface Languages {
	[language: string]: string;
}

interface Scripts {
	[script: string]: string;
}

interface Territories {
	[territory: string]: string;
}

interface CalendarTypes {
	[key: string]: string;
}

interface CollationTypes {
	[key: string]: string;
}

interface LineBreakTypes {
	[key: string]: string;
}

interface NumberTypes {
	[key: string]: string;
}

interface Types {
	calendar: CalendarTypes;
	collation: CollationTypes;
	lb: LineBreakTypes;
	numbers: NumberTypes;
}

interface LocaleDisplayPattern {
	localePattern: string;
	localeSeparator: string;
	localeKeyTypePattern: string;
}

interface CodePatterns {
	language: string;
	script: string;
	territory: string;
}

interface MeasurementSystemNames {
	[system: string]: string;
}

interface LocaleDisplayNames {
	languages: Languages;
	scripts: Scripts;
	territories: Territories;
	types: Types;
	measurementSystemNames: MeasurementSystemNames;
	localeDisplayPattern: LocaleDisplayPattern;
	codePatterns: CodePatterns;
}

interface Orientation {
	characterOrder: string;
	lineOrder: string;
}

interface Layout {
	orientation: Orientation;
}

interface Delimiters {
	quotationStart: string;
	quotationEnd: string;
	alternateQuotationStart: string;
	alternateQuotationEnd: string;
}

interface FormatTypes {
	abbreviated: string[] | Record<string, string>;
	narrow: string[] | Record<string, string>;
	wide: string[] | Record<string, string>;
	short: string[];
}

interface MonthFormats {
	format: FormatTypes;
	"stand-alone": FormatTypes;
}

interface DayFormats {
	format: FormatTypes;
	"stand-alone": FormatTypes;
}

interface QuarterFormats {
	format: FormatTypes;
	"stand-alone": FormatTypes;
}

interface DayPeriodFormats {
	format: {
		abbreviated: Record<string, string>;
		narrow: Record<string, string>;
		wide: Record<string, string>;
	};
	"stand-alone": {
		abbreviated: Record<string, string>;
		wide: Record<string, string>;
		narrow: Record<string, string>;
	};
}

interface EraFormats {
	Names: Record<string, string>;
	Abbr: Record<string, string>;
	Narrow: Record<string, string>;
}

interface DateFormats {
	full: string;
	long: string;
	medium: string;
	short: string;
}

interface TimeFormats {
	full: string;
	long: string;
	medium: string;
	short: string;
}

interface AvailableFormats {
	dateFormatItem: {
		Bh: string;
		Bhm: string;
		Bhms: string;
		d: string;
		E: string;
		EBhm: string;
		EBhms: string;
		Ed: string;
		Ehm: string;
		EHm: string;
		Ehms: string;
		EHms: string;
		Gy: string;
		GyMMM: string;
		GyMMMd: string;
		GyMMMEd: string;
		h: string;
		H: string;
		hm: string;
		Hm: string;
		hms: string;
		Hms: string;
		hmsv: string;
		Hmsv: string;
		hmv: string;
		Hmv: string;
		M: string;
		Md: string;
		MEd: string;
		MMM: string;
		MMMd: string;
		MMMEd: string;
		MMMMd: string;
		MMMMW: Record<string, string>;
		ms: string;
		y: string;
		yM: string;
		yMd: string;
		yMEd: string;
		yMMM: string;
		yMMMd: string;
		yMMMEd: string;
		yMMMM: string;
		yQQQ: string;
		yQQQQ: string;
		yw: Record<string, string>;
	};
}

interface IntervalFormatItems {
	Bh: { B: string; h: string };
	Bhm: { B: string; h: string; m: string };
	d: { d: string };
	Gy: { G: string; y: string };
	GyM: { G: string; M: string; y: string };
	GyMd: { d: string; G: string; M: string; y: string };
	GyMEd: { d: string; G: string; M: string; y: string };
	GyMMM: { G: string; M: string; y: string };
	GyMMMd: { d: string; G: string; M: string; y: string };
	GyMMMEd: { d: string; G: string; M: string; y: string };
	h: { a: string; h: string };
	H: { H: string };
	hm: { a: string; h: string; m: string };
	Hm: { H: string; m: string };
	hmv: { a: string; h: string; m: string };
	Hmv: { H: string; m: string };
	hv: { a: string; h: string };
	Hv: { H: string };
	M: { M: string };
	Md: { d: string; M: string };
	MEd: { d: string; M: string };
	MMM: { M: string };
	MMMd: { d: string; M: string };
	MMMEd: { d: string; M: string };
	y: { y: string };
	yM: { M: string; y: string };
	yMd: { d: string; M: string; y: string };
	yMEd: { d: string; M: string; y: string };
	yMMM: { M: string; y: string };
	yMMMd: { d: string; M: string; y: string };
	yMMMEd: { d: string; M: string; y: string };
	yMMMM: { M: string; y: string };
}

interface IntervalFormats {
	intervalFormatFallback: string;
	intervalFormatItem: IntervalFormatItems;
}

interface DateTimeFormats extends DateFormats {
	availableFormats: AvailableFormats;
	intervalFormats: IntervalFormats;
}

interface WeekData {
	firstDay: number;
	weekendStart: number;
	weekendEnd: number;
	minDays: number;
}

interface GregorianCalendar {
	months: MonthFormats;
	days: {
		format: {
			narrow: string[];
			abbreviated: string[];
			wide: string[];
			short: string[];
		};
		"stand-alone": {
			narrow: string[];
			abbreviated: string[];
			wide: string[];
			short: string[];
		};
	};
	quarters: {
		format: FormatTypes;
		"stand-alone": FormatTypes;
	};
	dayPeriods: DayPeriodFormats;
	eras: EraFormats;
	dateFormats: DateFormats;
	timeFormats: TimeFormats;
	dateTimeFormats: DateTimeFormats;
	weekData: WeekData;
}

interface Calendars {
	gregorian: GregorianCalendar;
}

interface RelativeTimeFormat {
	displayName: string;
	"-1"?: string;
	"0"?: string;
	"1"?: string;
	future: Record<string, string>;
	past: Record<string, string>;
	relativePeriod?: string;
}

interface Fields {
	era: RelativeTimeFormat;
	"era-short": RelativeTimeFormat;
	"era-narrow": RelativeTimeFormat;
	year: RelativeTimeFormat;
	"year-short": RelativeTimeFormat;
	"year-narrow": RelativeTimeFormat;
	quarter: RelativeTimeFormat;
	"quarter-short": RelativeTimeFormat;
	"quarter-narrow": RelativeTimeFormat;
	month: RelativeTimeFormat;
	"month-short": RelativeTimeFormat;
	"month-narrow": RelativeTimeFormat;
	week: RelativeTimeFormat;
	"week-short": RelativeTimeFormat;
	"week-narrow": RelativeTimeFormat;
	weekOfMonth: RelativeTimeFormat;
	"weekOfMonth-short": RelativeTimeFormat;
	"weekOfMonth-narrow": RelativeTimeFormat;
	day: RelativeTimeFormat;
	"day-short": RelativeTimeFormat;
	"day-narrow": RelativeTimeFormat;
	dayOfYear: RelativeTimeFormat;
	"dayOfYear-short": RelativeTimeFormat;
	"dayOfYear-narrow": RelativeTimeFormat;
	weekday: RelativeTimeFormat;
	"weekday-short": RelativeTimeFormat;
	"weekday-narrow": RelativeTimeFormat;
	weekdayOfMonth: RelativeTimeFormat;
	"weekdayOfMonth-short": RelativeTimeFormat;
	"weekdayOfMonth-narrow": RelativeTimeFormat;
	sun: RelativeTimeFormat;
	"sun-short": RelativeTimeFormat;
	"sun-narrow": RelativeTimeFormat;
	mon: RelativeTimeFormat;
	"mon-short": RelativeTimeFormat;
	"mon-narrow": RelativeTimeFormat;
	tue: RelativeTimeFormat;
	"tue-short": RelativeTimeFormat;
	"tue-narrow": RelativeTimeFormat;
	wed: RelativeTimeFormat;
	"wed-short": RelativeTimeFormat;
	"wed-narrow": RelativeTimeFormat;
	thu: RelativeTimeFormat;
	"thu-short": RelativeTimeFormat;
	"thu-narrow": RelativeTimeFormat;
	fri: RelativeTimeFormat;
	"fri-short": RelativeTimeFormat;
	"fri-narrow": RelativeTimeFormat;
	sat: RelativeTimeFormat;
	"sat-short": RelativeTimeFormat;
	"sat-narrow": RelativeTimeFormat;
	dayperiod: RelativeTimeFormat;
	"dayperiod-short": RelativeTimeFormat;
	"dayperiod-narrow": RelativeTimeFormat;
	hour: RelativeTimeFormat;
	"hour-short": RelativeTimeFormat;
	"hour-narrow": RelativeTimeFormat;
	minute: RelativeTimeFormat;
	"minute-short": RelativeTimeFormat;
	"minute-narrow": RelativeTimeFormat;
	second: RelativeTimeFormat;
	"second-short": RelativeTimeFormat;
	"second-narrow": RelativeTimeFormat;
	zone: RelativeTimeFormat;
	"zone-short": RelativeTimeFormat;
	"zone-narrow": RelativeTimeFormat;
}

interface TimeZoneNames {
	[zone: string]: string;
}

interface Dates {
	calendars: Calendars;
	fields: Fields;
	timeZoneNames: TimeZoneNames;
}

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
	timeSeparator: string;
}

interface CurrencyFormats {
	format: {
		standard: string;
		accounting: string;
	};
	short: Array<
		| string
		| {
				one: string;
				other: string;
		  }
	>;
}

interface DecimalFormats {
	format: string;
	long: Array<
		| string
		| {
				one?: string;
				other: string;
		  }
	>;
	short: Array<
		| string
		| {
				one?: string;
				other: string;
		  }
	>;
}

interface PercentFormats {
	format: string;
}

interface ScientificFormats {
	format: string;
}

interface NumberSystem {
	symbols: NumberSymbols;
	decimalFormats: DecimalFormats;
	percentFormats: PercentFormats;
	scientificFormats: ScientificFormats;
	currencyFormats: CurrencyFormats;
}

interface RegionalNumberSystemBase {
	[key: string]: NumberSystem;
}

type RegionalNumberSystemsKeys =
	| "unknown"
	| "adlm"
	| "arab"
	| "arabext"
	| "bali"
	| "beng"
	| "brah"
	| "cakm"
	| "cham"
	| "deva"
	| "fullwide"
	| "gong"
	| "gonm"
	| "gujr"
	| "guru"
	| "hanidec"
	| "java"
	| "kali"
	| "khmr"
	| "knda"
	| "lana"
	| "lanatham"
	| "laoo"
	| "latn"
	| "lepc"
	| "limb"
	| "mlym"
	| "mong"
	| "mtei"
	| "mymr"
	| "mymrshan"
	| "nkoo"
	| "olck"
	| "orya"
	| "osma"
	| "rohg"
	| "saur"
	| "shrd"
	| "sora"
	| "sund"
	| "takr"
	| "talu"
	| "tamldec"
	| "telu"
	| "thai"
	| "tibt"
	| "vaii";

type RegionalNumberSystems = Record<RegionalNumberSystemsKeys, NumberSystem>;

interface Numbers extends RegionalNumberSystems {
	defaultNumberingSystem: string;
	minimumGroupingDigits: number;
	pluralForm: Record<string, string>;
	ordinalForm: Record<string, string>;
}

interface UnitDisplayFormat {
	displayName?: string;
	one?: string;
	other: string;
	perUnitPattern?: string;
	east?: string;
	north?: string;
	south?: string;
	west?: string;
}

interface CompoundUnitPatterns {
	compoundUnitPattern: string;
}

interface UnitsByLength {
	per: CompoundUnitPatterns;
	times: CompoundUnitPatterns;
	"acceleration-g-force": UnitDisplayFormat;
	"acceleration-meter-per-second-squared": UnitDisplayFormat;
	"angle-revolution": UnitDisplayFormat;
	"angle-radian": UnitDisplayFormat;
	"angle-degree": UnitDisplayFormat;
	"angle-arc-minute": UnitDisplayFormat;
	"angle-arc-second": UnitDisplayFormat;
	"area-square-kilometer": UnitDisplayFormat;
	"area-hectare": UnitDisplayFormat;
	"area-square-meter": UnitDisplayFormat;
	"area-square-centimeter": UnitDisplayFormat;
	"area-square-mile": UnitDisplayFormat;
	"area-acre": UnitDisplayFormat;
	"area-square-yard": UnitDisplayFormat;
	"area-square-foot": UnitDisplayFormat;
	"area-square-inch": UnitDisplayFormat;
	"area-dunam": UnitDisplayFormat;
	"concentr-karat": UnitDisplayFormat;
	"concentr-milligram-per-deciliter": UnitDisplayFormat;
	"concentr-millimole-per-liter": UnitDisplayFormat;
	"concentr-part-per-million": UnitDisplayFormat;
	"concentr-percent": UnitDisplayFormat;
	"concentr-permille": UnitDisplayFormat;
	"concentr-permyriad": UnitDisplayFormat;
	"concentr-mole": UnitDisplayFormat;
	"consumption-liter-per-kilometer": UnitDisplayFormat;
	"consumption-liter-per-100kilometers": UnitDisplayFormat;
	"consumption-mile-per-gallon": UnitDisplayFormat;
	"consumption-mile-per-gallon-imperial": UnitDisplayFormat;
	"digital-petabyte": UnitDisplayFormat;
	"digital-terabyte": UnitDisplayFormat;
	"digital-terabit": UnitDisplayFormat;
	"digital-gigabyte": UnitDisplayFormat;
	"digital-gigabit": UnitDisplayFormat;
	"digital-megabyte": UnitDisplayFormat;
	"digital-megabit": UnitDisplayFormat;
	"digital-kilobyte": UnitDisplayFormat;
	"digital-kilobit": UnitDisplayFormat;
	"digital-byte": UnitDisplayFormat;
	"digital-bit": UnitDisplayFormat;
	"duration-century": UnitDisplayFormat;
	"duration-decade": UnitDisplayFormat;
	"duration-year": UnitDisplayFormat;
	"duration-year-person": UnitDisplayFormat;
	"duration-month": UnitDisplayFormat;
	"duration-month-person": UnitDisplayFormat;
	"duration-week": UnitDisplayFormat;
	"duration-week-person": UnitDisplayFormat;
	"duration-day": UnitDisplayFormat;
	"duration-day-person": UnitDisplayFormat;
	"duration-hour": UnitDisplayFormat;
	"duration-minute": UnitDisplayFormat;
	"duration-second": UnitDisplayFormat;
	"duration-millisecond": UnitDisplayFormat;
	"duration-microsecond": UnitDisplayFormat;
	"duration-nanosecond": UnitDisplayFormat;
	"electric-ampere": UnitDisplayFormat;
	"electric-milliampere": UnitDisplayFormat;
	"electric-ohm": UnitDisplayFormat;
	"electric-volt": UnitDisplayFormat;
	"energy-kilocalorie": UnitDisplayFormat;
	"energy-calorie": UnitDisplayFormat;
	"energy-foodcalorie": UnitDisplayFormat;
	"energy-kilojoule": UnitDisplayFormat;
	"energy-joule": UnitDisplayFormat;
	"energy-kilowatt-hour": UnitDisplayFormat;
	"energy-electronvolt": UnitDisplayFormat;
	"energy-british-thermal-unit": UnitDisplayFormat;
	"energy-therm-us": UnitDisplayFormat;
	"force-pound-force": UnitDisplayFormat;
	"force-newton": UnitDisplayFormat;
	"frequency-gigahertz": UnitDisplayFormat;
	"frequency-megahertz": UnitDisplayFormat;
	"frequency-kilohertz": UnitDisplayFormat;
	"frequency-hertz": UnitDisplayFormat;
	"graphics-em": UnitDisplayFormat;
	"graphics-pixel": UnitDisplayFormat;
	"graphics-megapixel": UnitDisplayFormat;
	"graphics-pixel-per-centimeter": UnitDisplayFormat;
	"graphics-pixel-per-inch": UnitDisplayFormat;
	"graphics-dot-per-centimeter": UnitDisplayFormat;
	"graphics-dot-per-inch": UnitDisplayFormat;
	"length-kilometer": UnitDisplayFormat;
	"length-meter": UnitDisplayFormat;
	"length-decimeter": UnitDisplayFormat;
	"length-centimeter": UnitDisplayFormat;
	"length-millimeter": UnitDisplayFormat;
	"length-micrometer": UnitDisplayFormat;
	"length-nanometer": UnitDisplayFormat;
	"length-picometer": UnitDisplayFormat;
	"length-mile": UnitDisplayFormat;
	"length-yard": UnitDisplayFormat;
	"length-foot": UnitDisplayFormat;
	"length-inch": UnitDisplayFormat;
	"length-parsec": UnitDisplayFormat;
	"length-light-year": UnitDisplayFormat;
	"length-astronomical-unit": UnitDisplayFormat;
	"length-furlong": UnitDisplayFormat;
	"length-fathom": UnitDisplayFormat;
	"length-nautical-mile": UnitDisplayFormat;
	"length-mile-scandinavian": UnitDisplayFormat;
	"length-point": UnitDisplayFormat;
	"length-solar-radius": UnitDisplayFormat;
	"light-lux": UnitDisplayFormat;
	"light-solar-luminosity": UnitDisplayFormat;
	"mass-metric-ton": UnitDisplayFormat;
	"mass-kilogram": UnitDisplayFormat;
	"mass-gram": UnitDisplayFormat;
	"mass-milligram": UnitDisplayFormat;
	"mass-microgram": UnitDisplayFormat;
	"mass-ton": UnitDisplayFormat;
	"mass-stone": UnitDisplayFormat;
	"mass-pound": UnitDisplayFormat;
	"mass-ounce": UnitDisplayFormat;
	"mass-ounce-troy": UnitDisplayFormat;
	"mass-carat": UnitDisplayFormat;
	"mass-dalton": UnitDisplayFormat;
	"mass-earth-mass": UnitDisplayFormat;
	"mass-solar-mass": UnitDisplayFormat;
	"power-gigawatt": UnitDisplayFormat;
	"power-megawatt": UnitDisplayFormat;
	"power-kilowatt": UnitDisplayFormat;
	"power-watt": UnitDisplayFormat;
	"power-milliwatt": UnitDisplayFormat;
	"power-horsepower": UnitDisplayFormat;
	"pressure-millimeter-of-mercury": UnitDisplayFormat;
	"pressure-pound-per-square-inch": UnitDisplayFormat;
	"pressure-inch-hg": UnitDisplayFormat;
	"pressure-bar": UnitDisplayFormat;
	"pressure-millibar": UnitDisplayFormat;
	"pressure-atmosphere": UnitDisplayFormat;
	"pressure-pascal": UnitDisplayFormat;
	"pressure-hectopascal": UnitDisplayFormat;
	"pressure-kilopascal": UnitDisplayFormat;
	"pressure-megapascal": UnitDisplayFormat;
	"speed-kilometer-per-hour": UnitDisplayFormat;
	"speed-meter-per-second": UnitDisplayFormat;
	"speed-mile-per-hour": UnitDisplayFormat;
	"speed-knot": UnitDisplayFormat;
	"temperature-generic": UnitDisplayFormat;
	"temperature-celsius": UnitDisplayFormat;
	"temperature-fahrenheit": UnitDisplayFormat;
	"temperature-kelvin": UnitDisplayFormat;
	"torque-pound-foot": UnitDisplayFormat;
	"torque-newton-meter": UnitDisplayFormat;
	"volume-cubic-kilometer": UnitDisplayFormat;
	"volume-cubic-meter": UnitDisplayFormat;
	"volume-cubic-centimeter": UnitDisplayFormat;
	"volume-cubic-mile": UnitDisplayFormat;
	"volume-cubic-yard": UnitDisplayFormat;
	"volume-cubic-foot": UnitDisplayFormat;
	"volume-cubic-inch": UnitDisplayFormat;
	"volume-megaliter": UnitDisplayFormat;
	"volume-hectoliter": UnitDisplayFormat;
	"volume-liter": UnitDisplayFormat;
	"volume-deciliter": UnitDisplayFormat;
	"volume-centiliter": UnitDisplayFormat;
	"volume-milliliter": UnitDisplayFormat;
	"volume-pint-metric": UnitDisplayFormat;
	"volume-cup-metric": UnitDisplayFormat;
	"volume-acre-foot": UnitDisplayFormat;
	"volume-bushel": UnitDisplayFormat;
	"volume-gallon": UnitDisplayFormat;
	"volume-gallon-imperial": UnitDisplayFormat;
	"volume-quart": UnitDisplayFormat;
	"volume-pint": UnitDisplayFormat;
	"volume-cup": UnitDisplayFormat;
	"volume-fluid-ounce": UnitDisplayFormat;
	"volume-fluid-ounce-imperial": UnitDisplayFormat;
	"volume-tablespoon": UnitDisplayFormat;
	"volume-teaspoon": UnitDisplayFormat;
	"volume-barrel": UnitDisplayFormat;
	coordinateUnit: UnitDisplayFormat;
}

interface Units {
	long: UnitsByLength;
	short: UnitsByLength;
	narrow: UnitsByLength;
}

interface ListPattern {
	start: string;
	middle: string;
	end: string;
	"2": string;
}

interface ListPatterns {
	standard: ListPattern;
	"standard-short": ListPattern;
	"standard-narrow": ListPattern;
	or: ListPattern;
	"or-short": ListPattern;
	"or-narrow": ListPattern;
	unit: ListPattern;
	"unit-short": ListPattern;
	"unit-narrow": ListPattern;
}

interface LocaleDefinition {
	identity: Identity;
	localeDisplayNames: LocaleDisplayNames;
	layout: Layout;
	delimiters: Delimiters;
	dates: Dates;
	numbers: Numbers;
	units: Units;
	listPatterns: ListPatterns;
}

export const LocaleDefinition: LocaleDefinition;
export const Identity: Identity;
export const LocaleDisplayNames: LocaleDisplayNames;
export const Layout: Layout;
export const Delimiters: Delimiters;
export const Dates: Dates;
export const Numbers: Numbers;
export const Units: Units;
export const ListPatterns: ListPatterns;
