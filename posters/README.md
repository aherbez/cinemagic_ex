# Posters

Here are files related to the poster generation system for Cinemagic. There's a fair amount going on here.

> Please note that the code in both of these locations represents an evolution over approximately two years of constant development, with both changing design and the necessity (given that we were a startup) of always needing to be able to demo. Also, both the tutorial system and the poster generation systems were some of the more complex aspects of the game. If I were to do it again, I would definitely break up the functionality more that is seen here, but much of that additional functionality was added as we went (and as we refined the game design).


## CharacterSprite.hx

This implements everything needed to render a given person, which can be a character (only), an actor (only), or the combination of an actor and a character. This mainly means layering specific images on top of each other, but the way skin tone is handled is a bit more involved.

More specifically, one of the files that gets loaded for any character (or the default actor/actress body, if no character has been specified) is a skin file, which encodes the shape of the skin layer in the red channel, the shadows in the blue channel, and the highlights in the green channel.

The actual skin color comes from the metadata for each actor/actress, and can be any arbitary RGB value. In `setSkinTone`, a new bitmap is created and filled with the skin tone color, and then the red channel of the input image is applied as the alpha, yielding a filled shape with the shape from the character data and the color from the actor.

Then, in `setSkinShading`, the same thing is done twice more, but with modified versions of the skin tone color (darker for shadows, lighter for highlights). The additional layers are also given appropriate blend modes (multiply for the shadows, screen for the highlights).

## PosterData.hx

PosterData contains all of the cards for a given poster/movie, as well as various functionality related to things like finding the dominant genre and generating the plot synopsis. Plots are generated based on data from the plot cards, each of which contains template text for both a main and a secondary plot.

Such plot text contains clauses for characters and locations, as in:

`A [pA|soldier] and a [pB|truck driver] work together to survive in [L|a city] destroyed by apocalyptic war and disease`

Each clause is enclosed in square brackets, with the first part signifying what kind of clause it is, and the second part providing a default value. So,

`a [pA|soldier]`

...would default to soldier, but the 'pA' would indicate that it should take the values from the first person added to the movie so far- if it's only an actor (let's say Bruce Cowbell), it would end up as:

`a soldier (Bruce Cowbell)`

...if, on the other hand, the first person is a character only (let's say a fireman), it would replace the default as in:

`a fireman`

But if the person has both a character and an actor, the character would be replaced and the actor name would be added:

`a fireman (Bruce Cowbell)`

There are also clauses to replace locations ("L") as well as clauses to change text based on the gender of a person. Such clauses can be nested, as in:

`must rescue [pB|[gA|his|her] family]`

...which would result defaulting to either "his family" or "her family" based on the gender of person A, but would instead use the character/actor information in person B, should it be filled out.

## Poster

This is responsible for building an actual poster image based on the information in the various cards. The positioning of the characters is taken from the main plot card, if there is one. Otherwise, default values are used. Pulling positions from the plot card allows for fun interactions between the character positions / scales with art added based on the plot card.

