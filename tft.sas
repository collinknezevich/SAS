/* establishing library */
x "cd S:/ind stff/";
libname tft ".";

/* data unable to be downloaded - had to manually enter 
   sourced from: https://lolchess.gg/ */
data tft.Champions;
  infile datalines;
  attrib Champion length = $15.;
  input Champion $ Games WinPct Top4Pct;
  datalines;
Taric 9 .11 .66
Orianna 8 .25 .62
Janna 8 .12 .62
Leona 8 .12 .5
Blitzcrank 8 0 .37
DrMundo 6 .33 .83
ChoGath 6 .16 .5
Malzahar 6 .16 .5
Yone 5 .4 .8
KaiSa 5 .4 .6
;
run; 

data tft.Comps;
  infile datalines;
  attrib Trait length = $15.;
  input Trait $ Games WinPct Top4Pct;
  datalines;
Enchanter 12 .16 .58
Bruiser 11 .18 .45
Socialite 11 .09 .63
Bodyguard 9 .11 .55
Enforcer 8 .12 .37
Academy 7 .14 .42
Challenger 6 .33 .5
Arcanist 6 .16 .5
Protector 6 0 .5
Clockwork 5 .4 .6
;
run; 

/* establishing format for conditional color formatting */
proc format;
  value winfmt
    low - 0.04 = "cxFF0000"
    0.04 - 0.08 = "cxFF6666"
    0.08 - 0.115 = "cxFFCCCC"
    0.115 - 0.135 = "cxFFFFFF"
    0.135 - 0.18 = "cxE5FFCC"
    0.18 - 0.22 = "cxCCFF99"
    0.22 - 0.26 = "cx99FF33"
    0.26 - high = "cx00FF00"
  ;
  value topfmt 
    low - 0.2 = "cxFF0000"
    0.2 - 0.35 = "cxFF6666"
    0.35 - 0.45 = "cxFFCCCC"
    0.45 - 0.55 = "cxFFFFFF"
    0.55 - 0.65 = "cxE5FFCC"
    0.65 - 0.75 = "cxCCFF99"
    0.75 - 0.85 = "cx99FF33"
    0.85 - high = "cx00FF00"
  ;
run; 

/* establishing attribute map datasets - to be used for images/icons in scatterplot */
data tft.attrmap;
  attrib ID length = $8.
         Value length = $15.
         markersymbol length = $15.
  ;
  input ID $ Value $ markersymbol $;
  datalines;
myid Taric TaricP
myid Orianna OriannaP
myid Janna JannaP
myid Leona LeonaP
myid Blitzcrank BlitzcrankP
myid DrMundo DrMundoP
myid ChoGath ChoGathP
myid Malzahar MalzaharP
myid Yone YoneP
myid KaiSa KaiSaP
;
run;

data tft.attrmapcomp;
  attrib ID length = $8.
         Value length = $15.
         markersymbol length = $15.
  ;
  input ID $ Value $ markersymbol $;
  datalines;
myid Enchanter EnchanterP
myid Bruiser BruiserP
myid Socialite SocialiteP
myid Bodyguard BodyguardP
myid Enforcer EnforcerP
myid Academy AcademyP
myid Challenger ChallengerP
myid Arcanist ArcanistP
myid Protector ProtectorP
myid Clockwork ClockworkP
;
run; 

ods listing close;
ods pdf file = "tft.pdf";
ods noproctitle;
options nodate;

title "Champion Placement Rates";
proc report data = tft.Champions;
  column Champion Games WinPct Top4Pct;
  define Champion / display;
  define Games / display;
  define WinPct / display style = [backgroundcolor = winfmt.];
  define Top4Pct / display style = [backgroundcolor = topfmt.];
run;
title;

title "Team Comp Placement Rates";
proc report data = tft.Comps;
  column Trait Games WinPct Top4Pct;
  define Trait / display;
  define Games / display;
  define WinPct / display style = [backgroundcolor = winfmt.];
  define Top4Pct / display style = [backgroundcolor = topfmt.];
run;
title;

/* images sourced from: https://lol.fandom.com/wiki/Category:Champion_Square_Images */
title "Champion Scatterplot";
proc sgplot data = tft.Champions 
            dattrmap = tft.attrmap;
  symbolimage name = TaricP image = "S:\ind stff\tft icons\TaricSquare.png";
  symbolimage name = OriannaP image = "S:\ind stff\tft icons\OriannaSquare.png";
  symbolimage name = JannaP image = "S:\ind stff\tft icons\JannaSquare.png";
  symbolimage name = LeonaP image = "S:\ind stff\tft icons\LeonaSquare.png";
  symbolimage name = BlitzcrankP image = "S:\ind stff\tft icons\BlitzcrankSquare.png";
  symbolimage name = DrMundoP image = "S:\ind stff\tft icons\DrMundoSquare.png";
  symbolimage name = ChoGathP image = "S:\ind stff\tft icons\ChoGathSquare.png";
  symbolimage name = MalzaharP image = "S:\ind stff\tft icons\MalzaharSquare.png";
  symbolimage name = YoneP image = "S:\ind stff\tft icons\YoneSquare.png";
  symbolimage name = KaiSaP image = "S:\ind stff\tft icons\KaiSaSquare.png";
  scatter y = WinPct x = Top4Pct / datalabel = Champion attrid = myid
                                   markerattrs = (size = 15pt)
                                   group = Champion;
  yaxis label = "Win%" values = (0 to 0.5 by 0.1);
  xaxis label = "Top 4 %" values = (0 to 1 by 0.2);
  refline 0.125 / axis = y lineattrs=(color = green pattern = dash);
  refline 0.5 / axis = x lineattrs=(color = green pattern = dash);
run;
title;

/* icons sourced from: https://lolchess.gg/ */
title "Team Comp Scatterplot";
proc sgplot data = tft.Comps
            dattrmap = tft.attrmapcomp;
  symbolimage name = EnchanterP image = "S:\ind stff\tft icons\Enchanter.png";
  symbolimage name = BruiserP image = "S:\ind stff\tft icons\Bruiser.png";
  symbolimage name = SocialiteP image = "S:\ind stff\tft icons\Socialite.png";
  symbolimage name = BodyguardP image = "S:\ind stff\tft icons\Bodyguard.png";
  symbolimage name = EnforcerP image = "S:\ind stff\tft icons\Enforcer.png";
  symbolimage name = AcademyP image = "S:\ind stff\tft icons\Academy.png";
  symbolimage name = ChallengerP image = "S:\ind stff\tft icons\Challenger.png";
  symbolimage name = ArcanistP image = "S:\ind stff\tft icons\Arcanist.png";
  symbolimage name = ProtectorP image = "S:\ind stff\tft icons\Protector.png";
  symbolimage name = ClockworkP image = "S:\ind stff\tft icons\Clockwork.png";
  scatter y = WinPct x = Top4Pct / datalabel = Trait attrid = myid 
                                   markerattrs = (size = 15pt)
                                   group = Trait;
  yaxis label = "Win%" values = (0 to 0.5 by 0.1);
  xaxis label = "Top 4 %" values = (0 to 1 by 0.2);
  refline 0.125 / axis = y lineattrs=(color = green pattern = dash);
  refline 0.5 / axis = x lineattrs=(color = green pattern = dash);
run;
title;

ods pdf close;
