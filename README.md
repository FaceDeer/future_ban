A Minetest mod that adds a "future_ban" command to queue an offline player for banning when they next join. Players need to have the "ban" priviledge to use this command.

The list of player names to be banned is stored in the "future_ban.lua" file in the world folder for a particular game. As soon as a player with a name on this list logs in they will be immediately banned. In this way the IP address of the player doesn't need to be known at the time the ban is issued.

# Usage

``/future_ban`` without a player name will present a list of the names currently stored for banning. These players have not yet been banned. As soon as a player with a matching name logs in they'll be banned and removed from the list.

``/future_ban <name>`` Adds a player name to the ban list, or removes it if it's already on the list.

# Licensing

This mod was originally created by PilzAdam in 2012 and [published under the WTFPL](https://forum.minetest.net/viewtopic.php?id=4268). It was rehosted and relicensed to MIT licensing by FaceDeer in 2019.