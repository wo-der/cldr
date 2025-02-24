import { LocaleDefinition } from "./Data/DataTemplate";
import { Language } from "./Locale";

interface LocaleData {
	Exists: (locale: string) => boolean;

	Load: (locale: string) => LocaleDefinition;

	LoadTable: (locale: string, table: Record<Language, LocaleDefinition>) => LocaleDefinition;

	LoadFolder: (locale: string, folder: Instance) => LocaleDefinition;
}

export const LocaleData: LocaleData;
