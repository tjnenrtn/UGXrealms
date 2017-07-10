## [chatdam]
### A mod to control chat spam and flooding.
--
--	That Dam Chat
--	Wait, it's a Chat Dam
--	Anyway, the pun failed
--
--	License : WTFPL
--	ßÿ Lymkwi/LeMagnesium/Mg
--

#### minetest.conf settings:

-- Spam control
maximum_characters_per_message = 255  -- Max allowed characters in a single chat message.

-- Flood control
flood_interval = 2 -- Interval in seconds that is checked for flooding.
maximum_messages_per_interval = 3  -- Max allowed chat messages per interval.