interface OperandResult {
	n: string;
	i: string;
	v: number;
	w: number;
	f: string;
	t: string;
}

interface PluralRuleSet {
	zero?: string;
	one?: string;
	two?: string;
	few?: string;
	many?: string;
	other?: string;
}

type PluralCategory = "zero" | "one" | "two" | "few" | "many" | "other";

interface PluralRuleFunction {
	(n: number): PluralCategory;
}

interface Plural {
	PluralRule(rules: PluralRuleSet): PluralRuleFunction;
}

export const Plural: Plural;
