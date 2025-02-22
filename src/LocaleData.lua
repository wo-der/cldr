do
local ld = {};

local _PARENTEXCEPTIONS = 
{
	['az_Arab'] = "root"; ['az_Cyrl'] = "root"; ['blt_Latn'] = "root"; ['bm_Nkoo'] = "root"; ['bs_Cyrl'] = "root"; ['byn_Latn'] = "root"; ['cu_Glag'] = "root"; ['dje_Arab'] = "root"; ['dyo_Arab'] = "root"; ['en_Dsrt'] = "root"; 
	['en_Shaw'] = "root"; ['ff_Adlm'] = "root"; ['ff_Arab'] = "root"; ['ha_Arab'] = "root"; ['iu_Latn'] = "root"; ['kk_Arab'] = "root"; ['ku_Arab'] = "root"; ['ky_Arab'] = "root"; ['ky_Latn'] = "root"; ['ml_Arab'] = "root"; ['mn_Mong'] = "root"; 
	['ms_Arab'] = "root"; ['pa_Arab'] = "root"; ['sd_Deva'] = "root"; ['sd_Khoj'] = "root"; ['sd_Sind'] = "root"; ['shi_Latn'] = "root"; ['so_Arab'] = "root"; ['sr_Latn'] = "root"; ['sw_Arab'] = "root"; ['tg_Arab'] = "root"; ['ug_Cyrl'] = "root";
	['uz_Arab'] = "root"; ['uz_Cyrl'] = "root"; ['vai_Latn'] = "root"; ['wo_Arab'] = "root"; ['yo_Arab'] = "root"; ['yue_Hans'] = "root"; ['zh_Hant'] = "root"; ['en_150'] = "en_001"; ['en_AG'] = "en_001"; ['en_AI'] = "en_001"; ['en_AU'] = "en_001";
	['en_BB'] = "en_001"; ['en_BM'] = "en_001"; ['en_BS'] = "en_001"; ['en_BW'] = "en_001"; ['en_BZ'] = "en_001"; ['en_CA'] = "en_001"; ['en_CC'] = "en_001"; ['en_CK'] = "en_001"; ['en_CM'] = "en_001"; ['en_CX'] = "en_001"; ['en_CY'] = "en_001";
	['en_DG'] = "en_001"; ['en_DM'] = "en_001"; ['en_ER'] = "en_001"; ['en_FJ'] = "en_001"; ['en_FK'] = "en_001"; ['en_FM'] = "en_001"; ['en_GB'] = "en_001"; ['en_GD'] = "en_001"; ['en_GG'] = "en_001"; ['en_GH'] = "en_001"; ['en_GI'] = "en_001";
	['en_GM'] = "en_001"; ['en_GY'] = "en_001"; ['en_HK'] = "en_001"; ['en_IE'] = "en_001"; ['en_IL'] = "en_001"; ['en_IM'] = "en_001"; ['en_IN'] = "en_001"; ['en_IO'] = "en_001"; ['en_JE'] = "en_001"; ['en_JM'] = "en_001"; ['en_KE'] = "en_001";
	['en_KI'] = "en_001"; ['en_KN'] = "en_001"; ['en_KY'] = "en_001"; ['en_LC'] = "en_001"; ['en_LR'] = "en_001"; ['en_LS'] = "en_001"; ['en_MG'] = "en_001"; ['en_MO'] = "en_001"; ['en_MS'] = "en_001"; ['en_MT'] = "en_001"; ['en_MU'] = "en_001";
	['en_MW'] = "en_001"; ['en_MY'] = "en_001"; ['en_NA'] = "en_001"; ['en_NF'] = "en_001"; ['en_NG'] = "en_001"; ['en_NR'] = "en_001"; ['en_NU'] = "en_001"; ['en_NZ'] = "en_001"; ['en_PG'] = "en_001"; ['en_PH'] = "en_001"; ['en_PK'] = "en_001";
	['en_PN'] = "en_001"; ['en_PW'] = "en_001"; ['en_RW'] = "en_001"; ['en_SB'] = "en_001"; ['en_SC'] = "en_001"; ['en_SD'] = "en_001"; ['en_SG'] = "en_001"; ['en_SH'] = "en_001"; ['en_SL'] = "en_001"; ['en_SS'] = "en_001"; ['en_SX'] = "en_001";
	['en_SZ'] = "en_001"; ['en_TC'] = "en_001"; ['en_TK'] = "en_001"; ['en_TO'] = "en_001"; ['en_TT'] = "en_001"; ['en_TV'] = "en_001"; ['en_TZ'] = "en_001"; ['en_UG'] = "en_001"; ['en_VC'] = "en_001"; ['en_VG'] = "en_001"; ['en_VU'] = "en_001";
	['en_WS'] = "en_001"; ['en_ZA'] = "en_001"; ['en_ZM'] = "en_001"; ['en_ZW'] = "en_001"; ['en_AT'] = "en_150"; ['en_BE'] = "en_150"; ['en_CH'] = "en_150"; ['en_DE'] = "en_150"; ['en_DK'] = "en_150"; ['en_FI'] = "en_150"; ['en_NL'] = "en_150";
	['en_SE'] = "en_150"; ['en_SI'] = "en_150"; ['es_AR'] = "es_419"; ['es_BO'] = "es_419"; ['es_BR'] = "es_419"; ['es_BZ'] = "es_419"; ['es_CL'] = "es_419"; ['es_CO'] = "es_419"; ['es_CR'] = "es_419"; ['es_CU'] = "es_419"; ['es_DO'] = "es_419";
	['es_EC'] = "es_419"; ['es_GT'] = "es_419"; ['es_HN'] = "es_419"; ['es_MX'] = "es_419"; ['es_NI'] = "es_419"; ['es_PA'] = "es_419"; ['es_PE'] = "es_419"; ['es_PR'] = "es_419"; ['es_PY'] = "es_419"; ['es_SV'] = "es_419"; ['es_US'] = "es_419";
	['es_UY'] = "es_419"; ['es_VE'] = "es_419"; ['pt_AO'] = "pt_PT"; ['pt_CH'] = "pt_PT"; ['pt_CV'] = "pt_PT"; ['pt_FR'] = "pt_PT"; ['pt_GQ'] = "pt_PT"; ['pt_GW'] = "pt_PT"; ['pt_LU'] = "pt_PT"; ['pt_MO'] = "pt_PT"; ['pt_MZ'] = "pt_PT"; 
	['pt_ST'] = "pt_PT"; ['pt_TL'] = "pt_PT"; ['zh_Hant_MO'] = "zh_Hant_HK"; 
};

local _READONLY = { __newindex = function(self, index, value) error(index .. " cannot be assigned to") end; __metatable = 'The metatable is locked' };

local data = script.Parent.Data;
local root_data = require(data.root);
local copy = require(script.Parent.Support).Copy;

local function _merge2(t1, t2)
	local r = copy.DeepCopy(t1);
	for k, v in pairs(t2) do
		if (type(v) == "table") and (type(r[k]) == "table") then
			r[k] = _merge2(r[k], t2[k]);
		else
			r[k] = v;
		end;
	end;
	return setmetatable(r, _READONLY);
end;

local function _merge(...)
	local tbl = { ... };
	local prev_tbl;
	for _, c_tbl in next, tbl do
		prev_tbl = _merge2(prev_tbl or {}, c_tbl);
	end;
	return prev_tbl;
end;

local function _get(locale)
	return require(data:FindFirstChild(locale));
end;

local function _get_parent(locale)
	local parent = _PARENTEXCEPTIONS[locale];
	if not parent then
		parent = locale:gsub('_?[^_]+$', '');
		if parent == '' then
			parent = 'root';
		end;
	end;
	return parent;
end;

function ld.Exists(locale)
	locale = tostring(locale);
	return data:FindFirstChild(locale) ~= nil;
end;

function ld.Load(locale)
	locale = tostring(locale);
	if locale == 'root' then
		return root_data;
	end;
	local parent = _get_parent(locale);
	return _merge(ld.Load(parent), _get(locale));
end;

function ld.LoadTable(locale, tbl)
	locale = tostring(locale);
	if locale == 'root' then
		return tbl.root or { };
	end;
	local parent = _get_parent(locale);
	return _merge(ld.LoadTable(parent, tbl), tbl[locale] or { });
end;

function ld.LoadFolder(locale, folder)
	locale = tostring(locale);
	local location = folder:FindFirstChild(locale);
	if locale == 'root' then
		if location then
			return require(location);
		end
		return { };
	end;
	local parent = _get_parent(locale);
	local r_table = { };
	if location then
		r_table = require(location);	
	end;
	return _merge(ld.LoadFolder(parent, folder), r_table);
end;

return ld;
end;