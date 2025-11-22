// Zeus Framework Configuration
// This mod provides advanced scripting and administrative tools for DayZ servers

class CfgPatches
{
	class Zeus_Scripts
	{
		requiredAddons[] = { "DZ_Scripts" };
		requiredVersion = 1.0;
	};
};

class CfgAddons
{
    class PreloadAddons
    {
        class Zeus
        {
            list[]={};
        };
    };
};

class CfgMods
{
    class Zeus
    {
        name="Zeus";
        dir="Zeus";
        picture="";
        action="";
        author="Zeus Development Team";
        overview = "Advanced mission scripting and administrative framework for DayZ servers";
		inputs = "Zeus/Scripts/Inputs.xml";
		type = "mod";
        defines[] = {};
		dependencies[] =
		{
			"Game", "World", "Mission"
		};

        class defs
		{
			class imageSets
			{
				files[]= {};
			};
			class widgetStyles
			{
				files[]= {};
			};

			class engineScriptModule 
			{ 
				files[] = { "Zeus/Scripts/1_Core"};
			};

			class gameScriptModule
			{
				files[] = { "Zeus/Scripts/3_Game" };
			};
			class worldScriptModule
			{
				files[] = { "Zeus/Scripts/4_World" };
			};

			class missionScriptModule 
			{
				files[] = { "Zeus/Scripts/5_Mission" };
			};
		};
    };
};
