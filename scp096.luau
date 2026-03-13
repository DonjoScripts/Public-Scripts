PublicIds = {
	-- Animation IDs
	Anim = {
		walk = 101931532422335,
		idle = 16102372293,
		rob = 13675136513,
		scream = 94305630911620,
		down = 180612465,
		dash = 117334637291968,
		dash2 = 89140327802925,
		charge = 89140327802925,
		handon = 79419402,
		grab = 78920796244566,
		Tpose = 188242481,
		leapCharge = 17569164461,
		leapDash = 17570131222,
		leapDown = 15437009238,
		leapDown2 = 80619025958459,
		unstoppable = 16176977527,
		critKick = 136125547655440,
		pslap1 = 97212410160106,
		pslap2 = 86093582820019,
		
		-- Attack animations
		slap1 = 92696348598076,
		slap2 = 126666659393201,
		slap3 = 135557283152371,
		critslap = 91293014684381,
		
		-- Glove attack animations (for detection)
		gloveAttack = {
			"13526154547", -- slap
			"16102850016", -- dual slap
			"13526158494", -- extended slap
			"16294032647", -- slapstick slap
			"90524879630106", -- slapstick slap2
			"134954960138305", -- friction slap
			"109511274923523", -- boxer 1
			"133068451086106", -- boxer 2
			"116559255414365", -- boxer 3
			"82224515307861", -- triple 1
			"126666659393201", -- triple 2
			"92696348598076", -- triple 3
			"86093582820019", -- Glaxe 1
			"97212410160106", -- Glaxe 2
			"16102722988", -- bull
			"135557283152371", -- silly
		},
		
		-- Custom attack animations
		customAttack = {
			"113925147812007", -- snowballsmash slap
			"13526154547", -- clock tyrant slap
			"15875650254", -- pan 1
			"15875619432", -- pan 2
			"16570306782", -- beatdown
		},
		
		-- Forbidden animations (immune states)
		forbidden = {
			16102819260, -- parry
			13671935940, -- rob idle 
			13675136513, -- rob transformation 
			17569574003, -- spoonful float
			17332793965, -- sbeve idle
			13552944381, -- Counter taunt 
			17332790610, -- sbeve idle2
			18139201258, -- elgato pet1
			18139141113, -- elgato pet2
		}
	},
	
	-- Sound Effects IDs
	SFX = {
		startScream = 114628630269809,
		endScream = 117812486049661,
		equipSuccess = 6265161006,
		equipFail = 877986525,
	},
	
	-- Image IDs
	Images = {
		-- Button images
		RButton = 82975918449230,
		EButton = 117753257776333,
		TButton = 104952241285295,
		FButton = 103761490643698,
		QButton = 79116086097383,
		banner = 132094587,
		
		-- Custom images
		scp096scream = 1215128623,
		scp096look = 139193159923874,
		robloxDefaultBtn = 97166444,
		iconBadge = 982385992,
		scp096banner = 103704449252010,
	},
	
	PlaceIds = {
		UTG = 115782629143468
	},
}

local loadedScript = false
local loadcountstart = tick()

game.StarterGui:SetCore("SendNotification", {Title = "System", Text = "Loading script!", Duration = 3})

spawn(function()
    repeat task.wait() until loadedScript
    game.StarterGui:SetCore("SendNotification", {Title = "System", Text = string.format("script loaded in %.3f seconds!", tick() - loadcountstart), Duration = 3})
end)

loadstring(game:HttpGet("https://pastefy.app/aOBEResc/raw"))()
loadedScript = true

