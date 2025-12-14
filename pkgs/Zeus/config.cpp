// Zeus Framework Configuration
// This mod provides advanced scripting and administrative tools for DayZ servers

class CfgPatches
{
	class Zeus
	{
		requiredAddons[] =
		{
			// 
		};
	};
};

class CfgMods
{
    class Zeus
    {
		type = "mod";

        class defs
		{
			
			class worldScriptModule
			{
				value = "";
				files[] =
				{
					"Scripts/4_World"
				};
			};
		};
    };
};
