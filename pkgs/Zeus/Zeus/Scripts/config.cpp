class CfgPatches
{
	class MT_Scripts
	{
		requiredAddons[] = { "DZ_Scripts" };
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
        name="";
        dir="Zeus";
        picture="";
        action="";
        author="";
        overview = "";
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