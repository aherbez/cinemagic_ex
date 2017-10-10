package com.jamwix.hs.tutorial;


class LoadingTips
{
	static public var LOADING_TIPS:Array<String> = [
		'Plot [GEM_PLOT] Cinebits give your movies a story!',
		'Cast actor [GEM_ACTOR] Cinebits to up your movies star power!',
		'Add character [GEM_CHARACTER] Cinebits to actors to beef up your movie!',
		'Add location [GEM_LOCATION] Cinebits to your movie to give it a setting!',
		'Match combos create powerful special gems. Try matching different gems to discover all the secret magic effects!',
		'Movies are made of 2 plots, 2 character, 2 actors, and just 1 location. You can have fewer, but you’ll make less at the box office.',
		'You’ll start with 1 free magic use every stage. Unlock more Cinebits and your special FX powers will increase higher and higher!',
		'Bonus [GEM_SPECIAL] Cinebits ALWAYS help your movie score more box office gold.',

		'Playable Cinebits in your hand can be discarded for a few gems!',
		'Add Cinebits to your filmstrip early to see what kind of movie genre you\'re building!',
		'The more Cinebits you collect, the more FX powers you get!',
		'Upgrade your Cinebit collection often to stay on top!',
		'Matching 5 colored gems gives you a rainbow gem that matches with anything!',
		'Matching 5 [GEM_CINEBIT] mystery boxes gives you a choice of Cinebits!',
		'Bonus Cinebits always help your movie, no matter what!',
		'Running low on cash? Play arcade mode and earn more!',
		'Tap a Cinebit to see what genres it works best with!',
		'A movie can hold 7 regular Cinebits and as many bonuses as you can fit!',
		'The more Cinebits in your collection, the better choices you\'ll have to win!',
		'FX power ups can help you turn a box office bomb into gold!'
	];

	static public function getRandomTip():String
	{
		var index:Int = Std.random(LOADING_TIPS.length);

		return LOADING_TIPS[index];
	}
}