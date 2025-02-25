import { Dates } from "./Dates";
import { Lists } from "./Lists";
import { Locale } from "./Locale";
import { Numbers } from "./Numbers";
import { Plural } from "./Plural";
import { Texts } from "./Texts";
import { Units } from "./Units";

import DateTimes from "./Support/DateTime";

declare namespace CLDR {
	export { Locale, Numbers, Plural, Dates, Lists, Units, Texts, DateTimes };
}

export = CLDR;
