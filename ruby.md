<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<style>
/* Page layout*/
html { padding: 2em; }
@media print { html { padding: 1em; } }

/* Titles */
h1 {
    margin-bottom: 3em;
    clear: right;
}
h2 { margin: 2rem 0 0; }
h3 { margin: 2rem 0 1rem; }
h2+h3 { margin-top: 0.5rem; }
h6 {
    font-size: inherit;
    font-weight: bold;
    display: inline;
    display: run-in;
    padding-right: 1em;
    margin: 0;
}

/*Figures and asides */
body {
    max-width: 32em;
    padding-right: 17em;
    margin: 1em auto;
}
aside > figure { margin: 0; }
aside {
    clear: right;
    float: right;
    width: 15em;
    margin-right: -17em;
    margin-bottom: 1em;
    break-inside: avoid;
    hyphens: auto;
}
@media screen and (max-width: 35em) {
    aside {
        margin-right: -2em;
        margin-left: 2em;
        width: 10em;
        border-top: 0.5px dotted gray;
    } 
    body { padding-right: 4em; }
}
figure img {
    display: block;
    margin: 0 auto 0;
    max-width: 100%;
}

/* Body Text */
body > p {
    margin: 0;
    text-indent: 1em;
}

/* Lists */
ol, ul { padding:0; }
li {
    margin: 0 0 0 1em;
    padding: 0;
}
li > p:first-of-type { margin-top: 0; }
li > p:last-of-type { margin-bottom: 0; }

/* Micro-typography */
.name { font-variant: small-caps; }

/* Fragmentation */
h1, h2, h3 {
    page-break-after: avoid;
    break-after: avoid;
}
.nobreak {
    page-break-inside: avoid;
    break-inside: avoid;
}

/* Utils */
b {color: red}
</style>

<aside>
2018/2/25 (Toshi <span class="name">Kobayashi</span>)<br>
Ver. 2.3<br>
Translation (Florian <span class="name">Rivoal</span>)<br>
</aside>

# Rules for Simple Placement of Ruby (Draft)

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
Note that the terminology is based on that defined in JLReq
(Requirements for Japanese Text  Layout).

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
    (the Japanese method for text layout).
    However, in some cases, optional steps are used.
6. The ruby font size is set to half of the base character's size as a default.
    However, the method supports using different sizes than 1/2.
7. While there are cases of ruby on both sides of the base string exist,
    the method defined here only handles ruby on one side.
    Handling both sides is left as a future exercise.

### Types of ruby

<aside><figure>
    <img src="img/fig1.svg">
    <figcaption><h6>Fig. 1</h6> Types of ruby</figcaption>
</figure></aside>
Ruby may be divided into the following 3 different types,
based on the relationship between the ruby and the base characters
(See JLReq “3.3.1 Usage of Ruby”).

1. Mono-ruby
2. Jukugo-ruby
3. Group-ruby
{:.nobreak}

Which one to use depends on the relationship
between the ruby and the base characters.
Mono-ruby is used to connect ruby to a single base character,
Jokugo-ruby is used when multiple base characters each have a corresponding ruby
and at the same time the whole group needs to be processed together,
and group-ruby is used when ruby is attached to a group of base characters together (see figure 1).
Each is used when specified. 

## Rules for Simple Placement of Ruby

### Ruby character size and character placement

<aside><figure>
    <img src="img/fig2.svg">
    <figcaption><h6>Fig. 2</h6> Example of vertical ruby</figcaption>
</figure></aside>
<aside><figure>
    <img src="img/fig3.svg">
    <figcaption><h6>Fig. 3</h6> Example of horizontal ruby</figcaption>
</figure></aside>
The size of the ruby characters
and their placement in the inline direction relative to the base characters is as follows:

1. The size of the ruby is by default set to
    half of the size of the base characters.
2. In vertical text, ruby is placed to the right of the base characters,
    and the character frame of the ruby is placed flush
    against the character frame of the base characters.
    (See figure 2)
3. In horizontal text, ruby is placed to the top of the base characters,
    and the character frame of the ruby is placed flush
    against the character frame of the base characters.
    (See figure 3)

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
        <figcaption><h6>Fig. 4</h6> Example mono-ruby with western characters</figcaption>
    </figure></aside>
    When the ruby is made of 2 or more characters,
    each character in the ruby string is placed
    immediately next to its neighboring character,
    without any inter-letter spacing.
    Furthermore, when the ruby is composed of characters such as
    Grouped numerals (cl-24),
    Unit symbols (cl-25),
    Western word space (cl-26),
    or Western characters (cl-27)
    which have their own individual width,
    they are placed based on each character's metrics.
    (See figure 4)
2. The center of the ruby string and of the base character string
     are aligned in the inline direction.
     (see figure 5).
3. Since the base character and its associated ruby form a single unit
    there is no line wrapping opportunity inside a mono-ruby.
4. <aside>
        <h6>Relation between protruding ruby and the surrounding characters</h6>
        <b>JIS  X 4051 では，親文字群(親文字及びそれ に付随するルビ)と，その前後に配置する 文字との関係について，ルビ文字を最大で ルビ文字の文字サイズまで，親文字群の前 後に配置する仮名にかけてよいという規定 とともに，“処理系定義として，ルビ文字 を前又は後ろの文字にかけずに配置しても よい”との規定も書かれている.</b>
    </aside>
    <aside><figure>
        <img src="img/fig5.svg">
        <figcaption><h6>Fig. 5</h6> Example 1 of mono-ruby protruding</figcaption>
    </figure></aside>
    <aside><figure>
        <img src="img/fig6.svg">
        <figcaption><h6>Fig. 6</h6> Example 2 of mono-ruby protruding</figcaption>
    </figure></aside>
    When the ruby string is longer than the base character string,
    the part of the ruby string that extends beyond the base characters
    must not hang over the characters preceding or following,
    if they are
    ideographic characters (cl-19),
    Hiragana (cl-15),
    Katakana (cl-16),
    etc.
    Space is introduced accordingly
    between these preceding or following characters and the base characters.
    (see figure 5)
    However, in the following cases,
    the ruby characters do hang over the preceding or following characters.
    (see figure 6)

    * If the character preceding the base character is one of:
        Closing brackets (cl-02),
        Full stops (cl-06),
        Commas (cl-07),
        or Middle dots (cl-05),
        then the ruby must hang over
        the blank portion at the end the character.
        (This blank portion is usually half the character's width,
        except in the case of Middle dots (cl-05)
        where it is a fourth of the character width).
        However, if this blank part has been compressed
        due to justification or similar processing of the line,
        then the ruby may only hang over the resulting
        compressed blank space
        (e.g. if it was reduced from half to a quarter em,
        hang at most a quarter em).
    * If the character following the base character is one of:
        Opening brackets (cl-01) or
        Middle dots (cl-05),
        then the ruby must hang over
        the blank portion at the start the character.
        (This blank portion is usually
        half the character's width for Opening brackets (cl-01),
        or a quarter of the character's width for Middle dots (cl-05))
        However, if this blank part has been compressed
        due to justification or similar processing of the line,
        then the ruby may only hang over the resulting
        compressed blank space
        (e.g. if it was reduced from half to a quarter em,
        hang at most a quarter em).
5. <aside><figure>
        <img src="img/fig7.svg">
        <figcaption><h6>Fig. 7</h6> Example of mono-ruby at the line start</figcaption>
    </figure></aside>
    <aside><figure>
        <img src="img/fig8.svg">
        <figcaption><h6>Fig. 8</h6> Example of mono-ruby at the line end</figcaption>
    </figure></aside>
    When the ruby string is longer than the base character string,
    and the ruby falls at the start of the line,
    then the start of the ruby string is aligned with the line's start edge
    (see figure 7),
    while if the ruby falls at the end of then line,
    then the end of the ruby string is aligned with the line's end edge
    (see figure 8),

### Placement of group-ruby

Group-ruby is placed as follows:

1. When the ruby string and the base character string
    are composed of characters such as
    Hiragana (cl-15),
    Katakana (cl-16),
    Ideographic characters (cl-19),
    and so on,
    excluding characters like
    Grouped numerals (cl-24),
    Unit symbols (cl-25),
    Western word space (cl-26),
    or Western characters (cl-27)
    which have their own individual width,
    the way they are positioned depends
    on how their respective lengths would
    compare if they were each laid out
    without any inter-letter spacing:

    * <aside><figure>
            <img src="img/fig9.svg">
            <figcaption><h6>Fig. 9</h6> Example 1 of group-ruby</figcaption>
        </figure></aside>
        When their respective lengths would be the same,
        both are laid out without inter-letter spacing
        and placed such that their respective centers in the inline direction are aligned
        (see figure 9).
    * <aside><figure>
            <img src="img/fig10.svg">
            <figcaption><h6>Fig. 10</h6> Example 2 of group-ruby</figcaption>
        </figure></aside>
        <aside><figure>
            <img src="img/fig11.svg">
            <figcaption><h6>Fig. 11</h6> Example 3 of group-ruby</figcaption>
        </figure></aside>
        When the ruby string is shorter than the base character string,
        space is inserted between every character in the ruby string
        as well as at the start and the end of the ruby string
        so that it becomes the same length as the base character string,
        then their centers in the inline direction are aligned.
        The size of the space inserted between each of the ruby characters
        is twice the size of the space inserted at the end and at the start
        (see figure 10).
        However, the size space inserted at the start and end must
        be capped at than half the size of one base character,
        and the space inserted between each ruby character is enlarged to compensate
        (see figure 11).
    * <aside><figure>
            <img src="img/fig12.svg">
            <figcaption><h6>Fig. 12</h6> Example 4 of group-ruby</figcaption>
        </figure></aside>
        When the ruby string is longer than the base character string,
        space is inserted between every character in the base character string
        as well as at the start and the end of the base character string
        so that it becomes the same length as the ruby string,
        then their centers in the inline direction are aligned.
        The size of the space inserted between each of the base characters
        is twice the size of the space inserted at the end and at the start
        (see figure 12).
2. <aside><figure>
        <img src="img/fig13.svg">
        <figcaption><h6>Fig. 13</h6> Example of ruby with western characters</figcaption>
    </figure></aside>
    When the base character string is composed of characters like
    Grouped numerals (cl-24),
    Unit symbols (cl-25),
    Western word space (cl-26),
    or Western characters (cl-27)
    which have their own individual width,
    and the ruby string is composed of characters such as
    Hiragana (cl-15),
    Katakana (cl-16),
    Ideographic characters (cl-19),
    and so on,
    the placement depends on the following (see figure 13):
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
    Grouped numerals (cl-24),
    Unit symbols (cl-25),
    Western word space (cl-26),
    or Western characters (cl-27)
    which have their own individual width,
    and the base character string is composed of characters such as
    Hiragana (cl-15),
    Katakana (cl-16),
    Ideographic characters (cl-19),
    and so on,
    the placement depends on the following (see figure 13):
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
        <figcaption><h6>Fig. 14</h6> Example of protruding group-ruby</figcaption>
    </figure></aside>
    When the ruby string is longer than the base character string and protrudes,
    whether and how it hangs over characters preceding or following
    the base character string 
    is handled in the same way as with mono-ruby
    (see figure 14).
    Also, when the ruby string is longer than the base character string,
    protrudes, and is located at the start or end of the line,
    the processing is also identical to that of mono-ruby.
5. <aside>
        <h6>Wrap opportunities in group-ruby</h6>
        As group ruby is treated as a unit, there is no wrap opportunity.
        <b>しかし，前述したように2行に分割する例もあり，このことを考慮すると，熟語ルビと同様に，グループルビでも，親文字とルビの組合せを考慮した分割ができることが望ましいといえよう．</b>
    </aside>
    <aside><figure>
        <img src="img/fig15.svg">
        <figcaption><h6>Fig. 15</h6> Example wrapping group-ruby</figcaption>
    </figure></aside>
    In the case of group ruby,
    the base character string and its associated ruby string
    are treated as a unit, 
    so there is no line wrapping opportunity inside either string.

### Placement of Jukugo-ruby

Jukugo-ruby is placed as follows:

1.  <aside><figure>
        <img src="img/fig16.svg">
        <figcaption><h6>Fig. 16</h6> Example 1 of jukugo-ruby</figcaption>
    </figure></aside>
    With jukugo-ruby, each base character is associated with its own ruby string.
    When the length of each of these ruby string laid out without inter-letter spacing
    is shorter than the length of all their corresponding base characters,
    placement is determined as follows:

    * When the ruby string associated with an individual base character is 1 character long,
        the ruby character and the base character
        are placed such that their respective centers in the inline direction are aligned
        (see figure 16).
    * When the ruby string associated with an individual base character is 2 characters long or more,
        the ruby string is laid out without inter-letter spacing,
        and placed such that its center and the center of its base character are aligned in the inline direction
        (see figure 16).
2. <aside><figure>
        <img src="img/fig17.svg">
        <figcaption><h6>Fig. 18</h6> Example 2 of jukugo-ruby</figcaption>
    </figure></aside>
    <aside><figure>
        <img src="img/fig18.svg">
        <figcaption><h6>Fig. 18</h6> Example 3 of jukugo-ruby</figcaption>
    </figure></aside>
    If even a single ruby string is longer than its corresponding base character
    when laid out without inter-letter spacing,
    the processing is identical to group-ruby
    (see figures 17 and 18).
3. With jukugo-ruby, individual base characters and their associated ruby string are treated as a unit,
    and line wrap opportunities are allowed between two base characters.
    When such a line wrap occurs,
    if a single base character that is part of the jukugo is placed alone at the end or at the start of a line,
    it is processed identically to mono-ruby;
    conversely when several base characters that are part of the jukugo
    are placed together at the end or start of a line,
    they are process together as has be described in this section about jukugo-ruby
    (see figure 19).
    <figure>
        <img src="img/fig19.svg">
        <figcaption><h6>Fig. 19</h6> Example of wrapping jukugo-ruby</figcaption>
    </figure>
4. When the ruby string is longer than the base character string and protrudes,
    whether and how it hangs over characters preceding or following
    the base character string 
    is handled in the same way as with mono-ruby.
    Also, when the ruby string is longer than the base character string,
    protrudes, and is located at the start or end of the line,
    the processing is also identical to that of mono-ruby.


