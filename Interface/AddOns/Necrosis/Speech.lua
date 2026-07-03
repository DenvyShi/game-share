------------------------------------------------------------------------------------------------------
-- Necrosis LdC
--
-- Crateur initial (US) : Infernal (http://www.shadydesign.com/necrosis/files/)
-- Implmentation de base (FR) : Tilienna Thorondor
-- Reprise du projet : Lomig & Nyx des Larmes de Cenarius, Kael'Thas
-- Skins et voix Franaises : Eliah, Ner'zhul
-- Version 01.05.2006-2
------------------------------------------------------------------------------------------------------


-- Les textes d'invocation du dmoniste
----------------------------------------
-- Ici sont rassembls les textes d'invocation pour le dmoniste. Vous pouvez les modifier
-- Pour qu'ils collent plus  votre personnage !
-- Pour ceci, voici une aide :
-- Les invocations sont de type "Blah blah blah" Le joueur invoqu "Blah blah blah"
-- Si vous voulez crire "Je vous invoque 'Nom du joueur' si vous cliquez sur mon portail"
-- Il faut savoir que le nom de la cible est remplac par <target>
-- alors il faudra rajouter avant } :
-- "Je vous invoque <target> si vous cliquez sur mon portail"
--
-- La mme chose est valable pour les messages de pierre d'me
--
-- En ce qui concerne l'invocation des dmons, a a l'air compliqu mais a ne l'est pas vraiment
-- Chaque dmon est numrot de 1  4
-- A l'intrieur de ces dmons chaque discours d'invocation est numrote de 1  x
-- A l'intrieur de ces discours d'invocation, des retours  la ligne sur la fenetre de chat est possible
-- J'espre que les commentaires que j'y ai mis sont comprhensibles
-- Sinon n'hsitez pas  poster dans le sujet du forum officiel ou crivez moi (lomig@larmes-cenarius.net)


-- Texts for a summoning by a warlock
--------------------------------------
-- Here are some summoning speeches for your warlock. You can change them for them to
-- fit your warlock-way-of-thinking a little more !
-- Need some help ? :)
-- Correct syntax is "Blah blah blah" SelectedPlayer "Blah blah blah"
-- If you want to write "In few seconds 'Player's name' will be able to help us"
-- The target's name is replaced by <target>
-- you need to add before the } :
-- "In few seconds <target> will be able to help us",
-- 
-- The same thing is available for soulstone messages
--
-- As for the demon summoning, it seems to be complicated but it is not
-- Each demon is numbered from 1 to 4
-- Inside those demons, each summon speech is numbered from 1 to x
-- Thoses speeches can contain several sentences in the chat window, in game
-- I made notes on the sentences given by example, I hope they are understandable
-- If not, do not hesistate to mail me (lomig@larmes-cenarius.net)


-- Texte fr das Ritual der Beschwrung
----------------------------------------
-- Hier sind einige Beschwrungstexte fr deinen Hexenmeister. Du kannst sie ndern
-- um deinen Hexenmeisterdenken ein wenig anzupassen!
-- Hier ein paar Tipps. :)
-- Der korrekte Syntax ist "Blah blah blah" ausgewlter Spieler "Blah blah blah"
-- Wenn du schreiben mchtest "In wenigen Sekunden wird 'Spielername' in der Lage sein uns zu helfen"
-- musst du vor dem }; hinzufgen:
-- "In wenigen Sekunden wird <target> in der Lage sein uns zu helfen",
-- 
-- Das gleiche gilt fr Seelenstein Nachrichten.
--
-- Das Beschwren von Dmonen: Es sieht zwar kompliziert aus, aber es ist nicht kompliziert
-- Jeder Dmon ist von 1 bis 4 durchnummeriert
-- Innerhalb dieser Dmonen ist jeder Beschwrungsspruch von 1 bis X durchnummeriert
-- Diese Sprche knnen einige Sequenzen enthalten, die ingame dann im Chatfenster angezeigt werden
-- Ich habe einige Anmerkungen bei den Beispielstzen hinzugefgt, ich hoffe sie sind verstndlich
-- Sollten sie es nicht sein, zgert nicht mich zu kontaktieren (lomig@larmes-cenarius.net)

-------------------------------------
--  CHINESE VERSION --
-------------------------------------

function Necrosis_Localization_Speech_Cn()

	NECROSIS_INVOCATION_MESSAGES = {
		[1] = {
			"正在召唤>><target><<, 需要2名队友合作,请右键点击传送门。",
		},
		[2] = {
			"正在召唤>><target><<, 需要2名队友合作,请右键点击传送门。",
		},
		[3] = {
			"正在召唤>><target><<, 需要2名队友合作,请右键点击传送门。",
		},
		[4] = {
			"正在召唤>><target><<, 需要2名队友合作,请右键点击传送门。",
		},
	};

	NECROSIS_SOULSTONE_ALERT_MESSAGE = {
		[1] = {
			">><target><<灵魂已经绑定。",
		},
		[2]= {
			">><target><<灵魂已经绑定。",
		},
	};

	NECROSIS_PET_MESSAGE = {
		-- Imp
		[1] = {
			-- Summon speech 1
			[1] = {
				"小鬼头<pet>，现在正是需要你的时候了，出来吧！",
			},
			-- Summon speech 2
			[2] = {
				"决定了，就是你了！<pet>！",
			},
		};
		-- Voidwalker
		[2] = {
			-- Summon speech 1
			[1] = {
				-- First sentence in the chat window
				"<pet>！应吾之求，速速现身！",
				-- Second setence in the chat window
				-- "<pet>！应吾之求，速速现身！",
			},
		};
		-- Succubus
		[3] = {
			-- Summon speech 1
			[1] = {
				"<pet>，亲爱的女王大人，欢迎来到这个世界！",
			},
		};
		-- Felhunter
		[4] = {
			-- Summon speech 1			
			[1] = {
				"正在呼叫不用喂食物的狗狗！<pet>！",
			},
		};
		-- Sentences for the first summon : When Necrosis do not know the name of your demons yet
		[5] = {
			-- Summon speech 1
			[1] = {
				-- First sentence in the chat window
				"Fishing ? Yes I love fishing... Look !",
				-- Second sentence in the chat window				
				"I close my eyes, I move my fingers like that... And voila ! Yes, yes, it is a fish, I can swear you !",
			},
			-- Summon speech 2			
			[2] = {
				-- First sentence in the chat window				
				"Anyway I hate you all ! I don't need you, I have friends.... Powerful friends !",
				-- Second sentence in the chat window				
				"COME TO ME, CREATURE OF HELL AND NIGHTMARE !",
			},
		};
		-- Sentences for the stead summon
		[6] = {
			-- Summon speech 1	
			[1] = {
				-- First sentence in the chat window
				"Hey, I'm late ! Let's find a horse that roxes !",
			},
			-- Summon speech 2	
			[2] = {
				-- First sentence in the chat window
				"I am summoning a stead from nightmare !",
				-- Second sentence in the chat window
				"AH AHA HA HA AH AH !",
			},
		};
	};
	
	NECROSIS_SHORT_MESSAGES = {
		{{"-->>><target><<被灵魂绑定３０分钟 <--"}},
		{{"<TP> 召唤>><target><<, 请点击传送门 <TP>"}},
	};

end

-------------------------------------
--  CHINESE TAIWAN VERSION --
-------------------------------------

function Necrosis_Localization_Speech_Tw()
	
	NECROSIS_INVOCATION_MESSAGES = {
		[1] = {
			">><player><<正在召喚>>%t<<, 需要2名隊友合作,請右鍵點擊傳送門,期間不要移動。",
		},
		[2] = {
			">><player><<正在召喚>>%t<<, 需要2名隊友合作,請右鍵點擊傳送門,期間不要移動。",
		},
		[3] = {
			">><player><<正在召喚>>%t<<, 需要2名隊友合作,請右鍵點擊傳送門,期間不要移動。",
		},
		[4] = {
			">><player><<正在召喚>>%t<<, 需要2名隊友合作,請右鍵點擊傳送門,期間不要移動。",
		},
	};

	NECROSIS_SOULSTONE_ALERT_MESSAGE = {
		[1] = {
			">><target><< 靈魂已經被偶綁定。",
		},
		[2]= {
			">><target><< 靈魂已經被偶綁定。",
		},
	};

	NECROSIS_PET_MESSAGE = {
		-- Imp
		[1] = {
			-- Summon speech 1
			[1] = {
				"Well, crapy nasty little Imp, now you stop sulking and you come to help ! AND THAT'S AN ORDER !",
			},
			-- Summon speech 2
			[2] = {
				"<pet>! HEEL ! NOW !",
			},
		};
		-- Voidwalker
		[2] = {
			-- Summon speech 1
			[1] = {
				-- First sentence in the chat window
				"Oops, I will probably need an idiot to be knocked for me...",
				-- Second setence in the chat window
				"<pet>, please help !",
			},
		};
		-- Succubus
		[3] = {
			-- Summon speech 1
			[1] = {
				"<pet> baby, please help me sweet heart !",
			},
		};
		-- Felhunter
		[4] = {
			-- Summon speech 1			
			[1] = {
				"<pet> ! <pet> ! Come on boy, come here ! <pet> !",
			},
		};
		-- Sentences for the first summon : When Necrosis do not know the name of your demons yet
		[5] = {
			-- Summon speech 1
			[1] = {
				-- First sentence in the chat window
				"Fishing ? Yes I love fishing... Look !",
				-- Second sentence in the chat window				
				"I close my eyes, I move my fingers like that... And voila ! Yes, yes, it is a fish, I can swear you !",
			},
			-- Summon speech 2			
			[2] = {
				-- First sentence in the chat window				
				"Anyway I hate you all ! I don't need you, I have friends.... Powerful friends !",
				-- Second sentence in the chat window				
				"COME TO ME, CREATURE OF HELL AND NIGHTMARE !",
			},
		};
		-- Sentences for the stead summon
		[6] = {
			-- Summon speech 1	
			[1] = {
				-- First sentence in the chat window
				"Hey, I'm late ! Let's find a horse that roxes !",
			},
			-- Summon speech 2	
			[2] = {
				-- First sentence in the chat window
				"I am summoning a stead from nightmare !",
				-- Second sentence in the chat window
				"AH AHA HA HA AH AH !",
			},
		};
	};
	
	NECROSIS_SHORT_MESSAGES = {
		{{"-->>><target><< 被靈魂綁定３０分鐘 <--"}},
		{{"<TP> 召喚>><target><<, 請點擊傳送門 <TP>"}},
	};

end

-------------------------------------
--  ENGLISH VERSION --
-------------------------------------

function Necrosis_Localization_Speech_En()

	NECROSIS_INVOCATION_MESSAGES = {
		[1] = {
			"Arcanum Taxi Cab ! I am summoning <target>, please click on the portal.",
		},
		[2] = {
			"Welcome aboard, <target>, you are flying on the ~Succubus Air Lines~ to <player>...",
			"Air Hostesses and their lashes are at your service during your trip !",
		},
		[3] = {
			"If you click on the portal, someone named <target> will appear and do your job for you !",
		},
		[4] = {
			"If you do not want a sprawling, phlegm-looking and asthmatic creature to come from this portal, click on it to help <target> find a path in Hell as quick as possible !",
		},
	};

	NECROSIS_SOULSTONE_ALERT_MESSAGE = {
		[1] = {
			"If you cherish the idea of a mass suicide, <target> now can self-resurrect, so all should be fine. Go ahead.",
		},
		[2]= {
			"<target> can go afk to drink a cup of coffee or so, soulstone is in place to allow for the wipe...",
		},
	};

	NECROSIS_PET_MESSAGE = {
		-- Imp
		[1] = {
			-- Summon speech 1
			[1] = {
				"Well, crapy nasty little Imp, now you stop sulking and you come to help ! AND THAT'S AN ORDER !",
			},
			-- Summon speech 2
			[2] = {
				"<pet>! HEEL ! NOW !",
			},
		};
		-- Voidwalker
		[2] = {
			-- Summon speech 1
			[1] = {
				-- First sentence in the chat window
				"Oops, I will probably need an idiot to be knocked for me...",
				-- Second setence in the chat window
				"<pet>, please help !",
			},
		};
		-- Succubus
		[3] = {
			-- Summon speech 1
			[1] = {
				"<pet> baby, please help me sweet heart !",
			},
		};
		-- Felhunter
		[4] = {
			-- Summon speech 1			
			[1] = {
				"<pet> ! <pet> ! Come on boy, come here ! <pet> !",
			},
		};
		-- Sentences for the first summon : When Necrosis do not know the name of your demons yet
		[5] = {
			-- Summon speech 1
			[1] = {
				-- First sentence in the chat window
				"Fishing ? Yes I love fishing... Look !",
				-- Second sentence in the chat window				
				"I close my eyes, I move my fingers like that... And voila ! Yes, yes, it is a fish, I can swear you !",
			},
			-- Summon speech 2			
			[2] = {
				-- First sentence in the chat window				
				"Anyway I hate you all ! I don't need you, I have friends.... Powerful friends !",
				-- Second sentence in the chat window				
				"COME TO ME, CREATURE OF HELL AND NIGHTMARE !",
			},
		};
		-- Sentences for the stead summon
		[6] = {
			-- Summon speech 1	
			[1] = {
				-- First sentence in the chat window
				"Hey, I'm late ! Let's find a horse that roxes !",
			},
			-- Summon speech 2	
			[2] = {
				-- First sentence in the chat window
				"I am summoning a stead from nightmare !",
				-- Second sentence in the chat window
				"AH AHA HA HA AH AH !",
			},
		};
	};
	
	NECROSIS_SHORT_MESSAGES = {
		{{"--> <target> is soulstoned for 30 minutes <--"}},
		{{"<TP> Summoning <target>, please click on the portal <TP>"}},
	};

end

-- Pour les caractres spciaux :
-- Besondere Zeichen :
--  = \195\169 ----  = \195\168
--  = \195\160 ----  = \195\162
--  = \195\180 ----  = \195\170
--  = \195\187 ----  = \195\164
--  = \195\132 ----  = \195\182
--  = \195\150 ----  = \195\188
--  = \195\156 ----  = \195\159
--  = \195\167 ----  = \195\174

