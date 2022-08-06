g_PluginInfo =
{
	Name = "HomeSetter Plugin",
	Date = "2022-07-17",
	Description = "This plugin provides the ability to manage your homes",
	AdditionalInfo =
    {
        {
            Title = "Lightweight & Fast",
            Contents = "The entire plugin fits on ~10KiB of disk space & has no unnecessary functionality.",
        },
        {
            Title = "Set your homes",
            Contents = "With this plugin, you can set home points and adjust the maximum number of them through permissions. You can teleport to homes through all dismensions!",
        },
        {
            Title = "Check your homes list",
            Contents = "Use /homes to see existing homes and their amount",
        },
    },
	Commands =
    {
        ["/home"] =
        {
            HelpString = "Teleports you to a home",
            Permission = "homesetter.home",
            Handler = TpHome,
            ParameterCombinations =
            {
                {
                    Params = "[home]",
                    Help = "Name of the home to teleport to",
                }
            },
        },
        ["/sethome"] =
        {
            HelpString = "Set a home",
            Permission = "homesetter.sethome",
            Handler = SetHome,
            ParameterCombinations =
            {
                {
                    Params = "[home]",
                    Help = "Name of the home that should be set",
                }
            },
        },
        ["/delhome"] =
        {
            HelpString = "Delete home",
            Permission = "homesetter.delhome",
            Handler = DelHome,
            ParameterCombinations =
            {
                {
                    Params = "[home]",
                    Help = "Name of the home that should be deleted",
                }
            },
        },
        ["/homes"] =
        {
            HelpString = "List of homes",
            Permission = "homesetter.homes",
            Handler = ViewHomes,
        },
    },
	ConsoleCommands = {},
	Permissions =
    {
        ["homesetter.home"] =
        {
            Description = "Allows the players to teleport to their homes.",
            RecommendedGroups = "Default",
        },
        ["homesetter.sethome"] =
        {
            Description = "Allows the players to set their homes.",
            RecommendedGroups = "Default",
        },
        ["homesetter.delhome"] =
        {
            Description = "Allows the players to delete their homes.",
            RecommendedGroups = "Default",
        },
        ["homesetter.homes"] =
        {
            Description = "Allows the players to view a list of their homes.",
            RecommendedGroups = "Default",
        },
        ["homesetter.maxhomes.3"] =
        {
            Description = "Maximum number of homes to be set",
            RecommendedGroups = "Default",
        },
    },
	Categories = {},
}