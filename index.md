---
lang: en
title: Rules for Simple Placement of Ruby (Draft)
noheader: true
nofooter: true
stylesheet: ./ruby.css
description: A simple set of rules for placement of Ruby text in Japanese typography.
---
<aside>
2018/3/16 (Toshi <span class="name">Kobayashi</span>)<br>
Ver. 2.3<br>
Translation (Florian <span class="name">Rivoal</span>)<br>
</aside>

# {{ page.title }}

## Table of Contents
{:.no-toc}

* Table of Contents
{:toc}

## Foreword

### The Difficulties of Ruby Processing

When performing ruby layout,
the following factors need to be considered
in order to decide on the position:

1. How to handle the correspondence between the base characters and the ruby
2. What to do when the string of base characters is longer than the ruby string
3. What to do when the string of base characters is shorter than the ruby string
4. <aside>
        <h6>Protrusion of ruby from base characters</h6>
        In movable type typesetting,
        ruby characters protruding from their base characters
        may not hang over neighboring kanji,
        but often were allowed to hang over neighboring kana.
        However, when the ruby is katakana,
        some publishers would set it so that
        it would not hang over the kana neighboring the base character.
        Also, when the characters around the base characters
        were kanji on one side and kana on the other side,
        for the sake of balance
        the ruby would sometimes be set so as to hang
        neither over the kanji nor over the kana
        (which would therefore both be spaced away from the base character).
    </aside>
    When the ruby string protrudes from the base character string,
    whether it can be allowed to be laid over the characters preceding or following,
    and whether this affects the position of the base characters
5. When the ruby string protrudes from the base character string,
    and the base character string is at the start or the end of the line,
    whether the base character string or the ruby string should be aligned with the line edge
6. <aside>
        <h6>Wrap opportunities</h6>
        In computer-based typesetting,
        However, in movable type typesetting,
        rather than always suppressing line wrap opportunities,
        they would be allowed in cases like compound words.
        This is because it may otherwise triggers very large
        spacing adjustments during justification.
    </aside>
    When there are multiple base characters,
    whether there can be line wrap opportunity between them

In movable type typography,
such matters were resolved based generic principles,
and could always be corrected during the proofreading phase.
Essentially, each case was adjusted individually in a flexible manner.

In computer-based typesetting,
the layout needs to be more or less determined based on predetermined rules,
but it remained necessary to adjust the results in certain cases,
for example by changing the association between base characters
and the ruby string,
or by switching to a different placement policy.

### Web Ruby placement

When thinking about computing placement for web content,
it is not practical to decide on the positioning
case by case as was done in movable type typography.
It is therefore necessary to decide upon comprehensive rules
that provide solutions to all the problems listed above,
so that placement may be determined fully automatically.
Considering all the possibilities that existed in movable type typesetting,
the system to be designed needs to be very complex.

However, when considering the ideal positioning of ruby,
it seems inevitable that exceptions will occur, causing issues.

In such cases, rather than ideal positioning,
we must at least make sure that the positioning causes no misunderstanding;
there are also practical limits to how complex the system can be
in order to be practically implementable.

The following is a proposal for a simple processing system.
Note that the terminology is based on that defined in
<a href="https://www.w3.org/TR/jlreq/"><abbr title="Requirements for Japanese Text Layout">JLReq</abbr></a>.

## Matters considered by the simple placement rules

### Matters considered by the simple placement rules

<aside>
    <h6>Ruby as notes</h6>
    Notes are sometimes placed between lines
    similarly to how ruby is laid out
    (inter-linear notes).
    The processing of this arrangement is not covered in this document.
</aside>
<aside>
    <h6>Reference size</h6>
    Because the size of ruby characters used in JIS X 4051 set to 1/2
    there are many examples that use the size of the ruby character as the reference.
    However, since ruby is not restricted to 1/2,
    this document uses the size the base character as the reference.
</aside>
<aside>
    <h6>Size of ruby characters</h6>
    In movable type typesetting,
    when ruby characters of size 3.5 points were not available,
    based characters of 7 points where sometimes paired
    with ruby characters of 4 points.
    Also, ruby associated with large base characters,
    such as those in titles,
    are sometimes smaller than 1/2.
</aside>

Here are the fundamental assumptions underlying the simple placement rules.

1. Ruby is used to display the reading or the meaning of the base characters.
    I therefore consider avoiding misreadings as the number one priority.
2. I have devised a method that attempts to reduce exceptions as much as possible.
    Therefore, there is no requirement for complex processing.
3. The method is agnostic to horizontal vs vertical writing,
    and will use the same logic in either case.
4. The method places the ruby string relative to the base character string
    the same way when they occur in the middle, start, or end of the line.
    Moreover, this method does not change the relative position
    of the ruby string to the base character string
    depending on preceding or subsequent characters.
    In other words, this method calculates a position
    for the ruby relative to the base string
    that does not change depending on context.
5. Generally speaking, the processing method is based on JIS X 4051
    (Formatting rules for Japanese documents).
    However, in some cases, optional steps are used.
6. The ruby font size is set to half of the base character's size as a default.
    However, the method supports using different sizes than 1/2.
7. While there are cases of ruby on both sides of the base string exist,
    the method defined here only handles ruby on one side.
    Handling both sides is left as a future exercise.

### Types of ruby

<aside><figure>
    <img src="img/fig1.svg">
    <figcaption><h6>Fig. 1</h6> Types of ruby</figcaption>
</figure></aside>
Ruby may be divided into the following 3 different types,
based on the relationship between the ruby and the base characters
(see <a href="https://www.w3.org/TR/jlreq/#usage_of_ruby">JLReq “3.3.1 Usage of Ruby”</a>).

1. Mono-ruby
2. Jukugo-ruby
3. Group-ruby
{:.nobreak}

Which one to use depends on the relationship
between the ruby and the base characters.
Mono-ruby is used to connect ruby to a single base character,
Jokugo-ruby is used when multiple base characters each have a corresponding ruby
and at the same time the whole group needs to be processed together,
and group-ruby is used when ruby is attached to a group of base characters together (see fig. 1).
Each is used when specified. 

## Rules for Simple Placement of Ruby

### Ruby character size and character placement

<aside><figure>
    <img src="img/fig2.svg">
    <figcaption><h6>Fig. 2</h6> Example of vertical ruby</figcaption>
</figure></aside>
<aside><figure>
    <img src="img/fig3.svg">
    <figcaption><h6>Fig. 3</h6> Example of horizontal ruby</figcaption>
</figure></aside>
The size of the ruby characters
and their placement in the inline direction relative to the base characters is as follows:

1. The size of the ruby is by default set to
    half of the size of the base characters.
2. In vertical text, ruby is placed to the right of the base characters,
    and the character frame of the ruby is placed flush
    against the character frame of the base characters.
    (see fig. 2)
3. In horizontal text, ruby is placed to the top of the base characters,
    and the character frame of the ruby is placed flush
    against the character frame of the base characters.
    (see fig. 3)

The following sections describe in detail the placement of
mono-ruby,
jukugo-ruby,
and group-ruby.
However, since jukugo-ruby is more complex,
it is explained last.

### Placement of mono-ruby

Mono-ruby is placed as follows:

1. <aside><figure>
        <img src="img/fig4.svg">
        <figcaption><h6>Fig. 4</h6> Example mono-ruby with western characters</figcaption>
    </figure></aside>
    When the ruby is made of two or more characters,
    each character in the ruby string is placed
    immediately next to its neighboring character,
    without any inter-letter spacing.
    Furthermore, when the ruby is composed of characters such as
    <a href="https://www.w3.org/TR/jlreq/#cl-24">Grouped numerals (cl-24)</a>,
    <a href="https://www.w3.org/TR/jlreq/#cl-25">Unit symbols (cl-25)</a>,
    <a href="https://www.w3.org/TR/jlreq/#cl-26">Western word space (cl-26)</a>,
    or <a href="https://www.w3.org/TR/jlreq/#cl-27">Western characters (cl-27)</a>
    which have their own individual width,
    they are placed based on each character's metrics.
    (see fig. 4)
2. The center of the ruby string and of the base character string
     are aligned in the inline direction.
     (see fig. 5).
3. Since the base character and its associated ruby form a single unit
    there is no line wrapping opportunity inside a mono-ruby.
4. <aside>
        <h6>Protruding over surrounding characters</h6>
        The main placement method defined in JIS X 4051
        allows some amout of overhang over the preceding and following base characters,
        but recognize the method defined here as an allowed variant.
    </aside>
    <aside><figure>
        <img src="img/fig5.svg">
        <figcaption><h6>Fig. 5</h6> Example 1 of mono-ruby protruding</figcaption>
    </figure></aside>
    <aside><figure>
        <img src="img/fig6.svg">
        <figcaption><h6>Fig. 6</h6> Example 2 of mono-ruby protruding</figcaption>
    </figure></aside>
    When the ruby string is longer than the base character string,
    the part of the ruby string that extends beyond the base characters
    must not hang over the characters preceding or following,
    if they are
    <a href="https://www.w3.org/TR/jlreq/#cl-19">ideographic characters (cl-19)</a>,
    <a href="https://www.w3.org/TR/jlreq/#cl-15">Hiragana (cl-15)</a>,
    <a href="https://www.w3.org/TR/jlreq/#cl-26">Katakana (cl-16)</a>,
    etc.
    Space is introduced accordingly
    between these preceding or following characters and the base characters.
    (see fig. 5)
    However, in the following cases,
    the ruby characters do hang over the preceding or following characters.
    (see fig. 6)

    * If the character preceding the base character is one of:
        <a href="https://www.w3.org/TR/jlreq/#cl-02">Closing brackets (cl-02)</a>,
        <a href="https://www.w3.org/TR/jlreq/#cl-06">Full stops (cl-06)</a>,
        <a href="https://www.w3.org/TR/jlreq/#cl-07">Commas (cl-07)</a>,
        or <a href="https://www.w3.org/TR/jlreq/#cl-05">Middle dots (cl-05)</a>,
        then the ruby must hang over
        the blank portion at the end the character.
        (This blank portion is usually half the character's width,
        except in the case of <a href="https://www.w3.org/TR/jlreq/#cl-05">Middle dots (cl-05)</a>
        where it is a fourth of the character width).
        However, if this blank part has been compressed
        due to justification or similar processing of the line,
        then the ruby may only hang over the resulting
        compressed blank space
        (e.g. if it was reduced from half to a quarter em,
        hang at most a quarter em).
    * If the character following the base character is one of:
        <a href="https://www.w3.org/TR/jlreq/#cl-01">Opening brackets (cl-01)</a> or
        <a href="https://www.w3.org/TR/jlreq/#cl-05">Middle dots (cl-05)</a>,
        then the ruby must hang over
        the blank portion at the start the character.
        (This blank portion is usually
        half the character's width for <a href="https://www.w3.org/TR/jlreq/#cl-01">Opening brackets (cl-01)</a>,
        or a quarter of the character's width for <a href="https://www.w3.org/TR/jlreq/#cl-05">Middle dots (cl-05)</a>)
        However, if this blank part has been compressed
        due to justification or similar processing of the line,
        then the ruby may only hang over the resulting
        compressed blank space
        (e.g. if it was reduced from half to a quarter em,
        hang at most a quarter em).
5. <aside><figure>
        <img src="img/fig7.svg">
        <figcaption><h6>Fig. 7</h6> Example of mono-ruby at the line start</figcaption>
    </figure></aside>
    <aside><figure>
        <img src="img/fig8.svg">
        <figcaption><h6>Fig. 8</h6> Example of mono-ruby at the line end</figcaption>
    </figure></aside>
    When the ruby string is longer than the base character string,
    and the ruby falls at the start of the line,
    then the start of the ruby string is aligned with the line's start edge
    (see fig. 7),
    while if the ruby falls at the end of then line,
    then the end of the ruby string is aligned with the line's end edge
    (see fig. 8),

### Placement of group-ruby

Group-ruby is placed as follows:

1. When the ruby string and the base character string
    are composed of characters such as
    <a href="https://www.w3.org/TR/jlreq/#cl-15">Hiragana (cl-15)</a>,
    <a href="https://www.w3.org/TR/jlreq/#cl-26">Katakana (cl-16)</a>,
    <a href="https://www.w3.org/TR/jlreq/#cl-19">Ideographic characters (cl-19)</a>,
    and so on,
    excluding characters like
    <a href="https://www.w3.org/TR/jlreq/#cl-24">Grouped numerals (cl-24)</a>,
    <a href="https://www.w3.org/TR/jlreq/#cl-25">Unit symbols (cl-25)</a>,
    <a href="https://www.w3.org/TR/jlreq/#cl-26">Western word space (cl-26)</a>,
    or <a href="https://www.w3.org/TR/jlreq/#cl-27">Western characters (cl-27)</a>
    which have their own individual width,
    the way they are positioned depends
    on how their respective lengths would
    compare if they were each laid out
    without any inter-letter spacing:

    * <aside><figure>
            <img src="img/fig9.svg">
            <figcaption><h6>Fig. 9</h6> Example 1 of group-ruby</figcaption>
        </figure></aside>
        When their respective lengths would be the same,
        both are laid out without inter-letter spacing
        and placed such that their respective centers in the inline direction are aligned
        (see fig. 9).
    * <aside><figure>
            <img src="img/fig10.svg">
            <figcaption><h6>Fig. 10</h6> Example 2 of group-ruby</figcaption>
        </figure></aside>
        <aside><figure>
            <img src="img/fig11.svg">
            <figcaption><h6>Fig. 11</h6> Example 3 of group-ruby</figcaption>
        </figure></aside>
        When the ruby string is shorter than the base character string,
        space is inserted between every character in the ruby string
        as well as at the start and the end of the ruby string
        so that it becomes the same length as the base character string,
        then their centers in the inline direction are aligned.
        The size of the space inserted between each of the ruby characters
        is twice the size of the space inserted at the end and at the start
        (see fig. 10).
        However, the size space inserted at the start and end must
        be capped at than half the size of one base character,
        and the space inserted between each ruby character is enlarged to compensate
        (see fig. 11).
    * <aside><figure>
            <img src="img/fig12.svg">
            <figcaption><h6>Fig. 12</h6> Example 4 of group-ruby</figcaption>
        </figure></aside>
        When the ruby string is longer than the base character string,
        space is inserted between every character in the base character string
        as well as at the start and the end of the base character string
        so that it becomes the same length as the ruby string,
        then their centers in the inline direction are aligned.
        The size of the space inserted between each of the base characters
        is twice the size of the space inserted at the end and at the start
        (see fig. 12).
2. <aside><figure>
        <img src="img/fig13.svg">
        <figcaption><h6>Fig. 13</h6> Example of ruby with western characters</figcaption>
    </figure></aside>
    When the base character string is composed of characters like
    <a href="https://www.w3.org/TR/jlreq/#cl-24">Grouped numerals (cl-24)</a>,
    <a href="https://www.w3.org/TR/jlreq/#cl-25">Unit symbols (cl-25)</a>,
    <a href="https://www.w3.org/TR/jlreq/#cl-26">Western word space (cl-26)</a>,
    or <a href="https://www.w3.org/TR/jlreq/#cl-27">Western characters (cl-27)</a>
    which have their own individual width,
    and the ruby string is composed of characters such as
    <a href="https://www.w3.org/TR/jlreq/#cl-15">Hiragana (cl-15)</a>,
    <a href="https://www.w3.org/TR/jlreq/#cl-26">Katakana (cl-16)</a>,
    <a href="https://www.w3.org/TR/jlreq/#cl-19">Ideographic characters (cl-19)</a>,
    and so on,
    the placement depends on the following (see fig. 13):
    * When their respective lengths would be the same,
        both are laid out without inter-letter spacing
        and placed such that their respective centers in the inline direction are aligned.
    * When the ruby string is shorter than the base character string,
        space is inserted between every character in the ruby string
        as well as at the start and the end of the ruby string
        so that it becomes the same length as the base character string,
        then their centers in the inline direction are aligned.
        The size of the space inserted between each of the ruby characters
        is twice the size of the space inserted at the end and at the start.
    * When the ruby string is longer than the base character string,
        both are laid out without inter-letter spacing
        and placed such that their respective centers in the inline direction are aligned.
        In this case, the ruby string protrudes from the base character string.
3. When the ruby string is composed of characters like
    <a href="https://www.w3.org/TR/jlreq/#cl-24">Grouped numerals (cl-24)</a>,
    <a href="https://www.w3.org/TR/jlreq/#cl-25">Unit symbols (cl-25)</a>,
    <a href="https://www.w3.org/TR/jlreq/#cl-26">Western word space (cl-26)</a>,
    or <a href="https://www.w3.org/TR/jlreq/#cl-27">Western characters (cl-27)</a>
    which have their own individual width,
    and the base character string is composed of characters such as
    <a href="https://www.w3.org/TR/jlreq/#cl-15">Hiragana (cl-15)</a>,
    <a href="https://www.w3.org/TR/jlreq/#cl-26">Katakana (cl-16)</a>,
    <a href="https://www.w3.org/TR/jlreq/#cl-19">Ideographic characters (cl-19)</a>,
    and so on,
    the placement depends on the following (see fig. 13):
    * When their respective lengths would be the same,
        both are laid out without inter-letter spacing
        and placed such that their respective centers in the inline direction are aligned.
    * When the ruby string is shorter than the base character string,
        both are laid out without inter-letter spacing
        and placed such that their respective centers in the inline direction are aligned.
    * When the ruby string is longer than the base character string,
        space is inserted between every character in the base character string
        as well as at the start and the end of the base character string
        so that it becomes the same length as the ruby string,
        then their centers in the inline direction are aligned.
        The size of the space inserted between each of the base characters
        is twice the size of the space inserted at the end and at the start.
4. <aside><figure>
        <img src="img/fig14.svg">
        <figcaption><h6>Fig. 14</h6> Example of protruding group-ruby</figcaption>
    </figure></aside>
    When the ruby string is longer than the base character string and protrudes,
    whether and how it hangs over characters preceding or following
    the base character string 
    is handled in the same way as with mono-ruby
    (see fig. 14).
    Also, when the ruby string is longer than the base character string,
    protrudes, and is located at the start or end of the line,
    the processing is also identical to that of mono-ruby.
5. <aside>
        <h6>Wrap opportunities in group-ruby</h6>
        As group-ruby is treated as a unit, there is no wrap opportunity.
        However, in some exceptional cases where it is wrapped,
        and is then processed similarly to jukugo-ruby
	(see fig. 15).
    </aside>
    <aside><figure>
        <img src="img/fig15.svg">
        <figcaption><h6>Fig. 15</h6> Wrapping group-ruby</figcaption>
    </figure></aside>
    In the case of group ruby,
    the base character string and its associated ruby string
    are treated as a unit, 
    so there is no line wrapping opportunity inside either string.

### Placement of Jukugo-ruby

Jukugo-ruby is placed as follows:

1.  <aside><figure>
        <img src="img/fig16.svg">
        <figcaption><h6>Fig. 16</h6> Example 1 of jukugo-ruby</figcaption>
    </figure></aside>
    With jukugo-ruby, each base character is associated with its own ruby string.
    When the length of each of these ruby string laid out without inter-letter spacing
    is shorter than the length of all their corresponding base characters,
    placement is determined as follows:

    * When the ruby string associated with an individual base character is 1 character long,
        the ruby character and the base character
        are placed such that their respective centers in the inline direction are aligned
        (see fig. 16).
    * When the ruby string associated with an individual base character is 2 characters long or more,
        the ruby string is laid out without inter-letter spacing,
        and placed such that its center and the center of its base character are aligned in the inline direction
        (see fig. 16).
2. <aside><figure>
        <img src="img/fig17.svg">
        <figcaption><h6>Fig. 17</h6> Example 2 of jukugo-ruby</figcaption>
    </figure></aside>
    <aside><figure>
        <img src="img/fig18.svg">
        <figcaption><h6>Fig. 18</h6> Example 3 of jukugo-ruby</figcaption>
    </figure></aside>
    If even a single ruby string is longer than its corresponding base character
    when laid out without inter-letter spacing,
    the processing is identical to group-ruby
    (see fig. 17 and 18).
3. With jukugo-ruby, individual base characters and their associated ruby string are treated as a unit,
    and line wrap opportunities are allowed between two base characters.
    When such a line wrap occurs,
    if a single base character that is part of the jukugo is placed alone at the end or at the start of a line,
    it is processed identically to mono-ruby;
    conversely when several base characters that are part of the jukugo
    are placed together at the end or start of a line,
    they are process together as has be described in this section about jukugo-ruby
    (see fig. 19).
    <figure>
        <img src="img/fig19.svg">
        <figcaption><h6>Fig. 19</h6> Example of wrapping jukugo-ruby</figcaption>
    </figure>
4. When the ruby string is longer than the base character string and protrudes,
    whether and how it hangs over characters preceding or following
    the base character string 
    is handled in the same way as with mono-ruby.
    Also, when the ruby string is longer than the base character string,
    protrudes, and is located at the start or end of the line,
    the processing is also identical to that of mono-ruby.
