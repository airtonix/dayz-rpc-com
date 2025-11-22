// Zeus Logging System

class ZeusLog
{
	// Color codes for console output
	static const string COLOR_RED = "[c=FF0000]";
	static const string COLOR_GREEN = "[c=00FF00]";
	static const string COLOR_YELLOW = "[c=FFFF00]";
	static const string COLOR_BLUE = "[c=0000FF]";
	static const string COLOR_RESET = "[/c]";
	
	static void Info(string message)
	{
		Print("[ZEUS] " + message);
	}
	
	static void Warning(string message)
	{
		Print("[ZEUS WARNING] " + message);
	}
	
	static void Error(string message)
	{
		Print("[ZEUS ERROR] " + message);
	}
	
	static void Banner(string title)
	{
		Print("[ZEUS] ==========================================");
		Print("[ZEUS] " + title);
		Print("[ZEUS] ==========================================");
	}
};
