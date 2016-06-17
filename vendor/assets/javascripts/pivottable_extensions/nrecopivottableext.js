// 
// NReco PivotTable Extensions
// Author: Vitaliy Fedorchenko
// 
// Copyright (c) nrecosite.com - All Rights Reserved
// THIS CODE AND INFORMATION ARE PROVIDED "AS IS" WITHOUT WARRANTY OF ANY 
// KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE
// IMPLIED WARRANTIES OF MERCHANTABILITY AND/OR FITNESS FOR A
// PARTICULAR PURPOSE.
//
eval(function(p,a,c,k,e,d){e=function(c){return(c<a?'':e(parseInt(c/a)))+((c=c%a)>35?String.fromCharCode(c+29):c.toString(36))};if(!''.replace(/^/,String)){while(c--){d[e(c)]=k[c]||e(c)}k=[function(e){return d[e]}];e=function(){return'\\w+'};c=1};while(c--){if(k[c]){p=p.replace(new RegExp('\\b'+e(c)+'\\b','g'),k[c])}}return p}('(7(){6 f;f=2P;6 x=7(c,d,a){C("7"==25 c.N.1K)f(a).S("2O").2s("1k","1J.2n,1J.2M",7(){6 a=f(i).17("2N").2S(" "),h=-1,k=-1;0<=f.1I("2n",a)&&f.11(a,7(){0==i.J("2p")&&(k=1y(i.1C(3)));0==i.J("2I")&&(h=1y(i.1C(3)))});C(0<=f.1I("2B",a))6 b=f(i).17("W-o"),k=1y(b.1C(3));0<=f.1I("2G",a)&&(b=f(i).17("W-o"),h=1y(b.1C(3)));a={};C(0<=h)o(b=0;b<d.1G.j;b++){6 m=d.1d()[h];a[d.1G[b]]=m[b]}C(0<=k)o(b=0;b<d.1A.j;b++)m=d.1b()[k],a[d.1A[b]]=m[b];c.N.1K(a)})},r=7(c,d,a){6 e=[],h,k,b;c.P=!1;6 m=c.1b(),g=c.1d();o(b 10 m)h=m[b],k=8!=d?g[d]:[],k=c.19(h,k),e.E({14:k.13(),1u:h});e.4(7(c,b){L a*f.1L.1N(c.14,b.14)});c.1F=[];o(b=0;b<e.j;b++)c.1F.E(e[b].1u);c.P=!0},u=7(c,d,a){6 e=[],h,k,b;c.P=!1;6 m=c.1b(),g=c.1d();o(b 10 g)k=g[b],h=8!=d?m[d]:[],h=c.19(h,k),e.E({14:h.13(),1u:k});e.4(7(c,b){L a*f.1L.1N(c.14,b.14)});c.1D=[];o(b=0;b<e.j;b++)c.1D.E(e[b].1u);c.P=!0},y=7(c,d,a,e,h){6 k=7(a,c){a.S("O"==c?"1t":"1m")},b=7(c,b,e,g){b.1k(7(){6 b=f(i),k=b.W("1T"),l=c[k];b.X("1m")?(g(d,k,-1),a.4={M:"O"},a.4[e]=l):b.X("1t")?(d.P=!1,a.4=8):(g(d,k,1),a.4={M:"1g"},a.4[e]=l);h()}).11(7(){C(a.4&&a.4[e]){6 b=f(i);c[b.W("1T")].1c("15")==a.4[e].1c("15")&&k(b,a.4.M)}})},m=7(a,b){6 c=0;b.11(7(){6 b=f(i),d=f.2w(b.1H()),e=a[c];8!=e&&0<e.j&&e[e.j-1]==d&&(b.S("1V").W("1T",c),c++)})},g=d.1d();m(g,f(e).G(\'.1v[1j="1"]\'));b(g,f(e).G(\'.1v.1V[1j="1"]\'),"1i",r);g=d.1b();m(g,f(e).G(\'.1w[2j="1"]\'));b(g,f(e).G(\'.1w.1V[2j="1"]\'),"1n",u);c.N.2k&&f(e).G(".3t").11(7(){6 b=f(i),c=f.2w(b.1H()),d=0<b.1X().G(".1v").j;b.W("2o",c);b.S(d?"1S":"2a");a.4&&(!d||a.4.1n||a.4.16)&&(d||a.4.1i||a.4.18)||k(b,a.4&&a.4.U&&"O"==a.4.U[c]?"O":"1g")}).1k(7(){6 b=f(i),c=b.W("2o"),e=b.X("1S");a.4||(a.4={});a.4.U||(a.4.U={});b.X("1m")?a.4.U[c]="O":a.4.U[c]="1g";d.P=!1;e?(a.4.1n=8,a.4.16=!1):(a.4.1i=8,a.4.18=!1);h()});f(e).G("1e:24 .1p").S("23").1k(7(){6 b=f(i);b.X("1m")?(u(d,8,-1),a.4={M:"O",16:!0}):b.X("1t")?(d.P=!1,a.4=8):(u(d,8,1),a.4={M:"1g",16:!0});h()}).11(7(){6 b=f(i);a.4&&a.4.16&&k(b,a.4.M)});f(e).G("1e:21 .1p").S("22").1k(7(){6 b=f(i);b.X("1m")?(r(d,8,-1),a.4={M:"O",18:!0}):b.X("1t")?(d.P=!1,a.4=8):(r(d,8,1),a.4={M:"1g",18:!0});h()}).11(7(){6 b=f(i);a.4&&a.4.18&&k(b,a.4.M)})};1a.Z=7(c){i.N=f.3b({},Z.2m,c)};1a.Z.1x.1R=7(c,d){c.1z||(c.1z=c.2u,c.2u=7(b){6 a=c.1z?c.1z(b):8;a||(a=f.1L.1N);L d&&d.4&&d.4.U&&"O"==d.4.U[b]?7(b,c){L-a(b,c)}:a});c.P=!1;C(d&&d.4){6 a="O"==d.4.M?-1:1;C(d.4.1i){6 e=c.1d(),h=d.4.1i.1c("15"),k;o(k 10 e)h==e[k].1c("15")&&r(c,k,a)}1Q C(d.4.1n)o(k 10 e=c.1b(),h=d.4.1n.1c("15"),e)h==e[k].1c("15")&&u(c,k,a);1Q d.4.16?u(c,8,a):d.4.18&&r(c,8,a)}};6 z=7(c,d,a){6 e=Q.R("1e");e.9.2T="2L";a=Q.R("1J");a.1B("1j",d.1D.j+1);e.K(a);d=Q.R("1h");d.H="1w";d.1B("1j",f(c).G("1e:24 1h.1p").17("1j"));f(c)[0].K(e);e.2z(d,a);c=f(Q.R("a"));c[0].1B("2y","2x");c.1H("1U 2q.2g 2K");f(a).2D("2J 2H ");a.K(c[0]);a.9.27=c[0].9.27="#2E";c[0].9.2F="2U";f(c[0]).17("2t","2Z://2h.2f.2e/2c.2d")};1a.Z.1x.3k=7(c){6 d=i;L 7(a,e){6 h,k;d.1R(a,e);h=c(a,e);k=7(){6 b=c(a,e);x(d,a,b);y(d,a,e,b,k);f(h).3l(b);h=b;z(h,a,e);d.N.2l&&d.29(f(h),!0);C("7"==25 d.N.1O)d.N.1O()};x(d,a,h);y(d,a,e,h,k);z(h,a,e);L 7(a){C(d.N.1P){6 c=f(d.N.1P);c.3g(a);a=c}L a}(h)}};1a.Z.1x.29=7(c,d){C(0!=c.j){6 a=d?c.3m(".28"):c.1X();a.S("28");o(6 e=[],h=[],k=[],b=[],m=[],g=c[0].3s("3r"),n=0;n<g.j;n++){6 l=g[n],p=0<=l.H.J("1S"),q=0<=l.H.J("2a"),t=0<=l.H.J("1v")||0<=l.H.J("22"),v=0<=l.H.J("1w")||0<=l.H.J("23"),w={1h:l,I:l.1q,D:l.1Y,20:t,1Z:v,Y:l.Y,12:l.12};t||(w.T=1);v||(w.F=1);e.E(w);q&&b.E(l);p&&m.E(l)}c.S("26");o(n=0;n<e.j;n++){g=e[n];l=g.1h;p=g.D;l.9.D=p+"s";q=Q.R("1o");(g.20||g.1Z)&&q.1B("34",l.1s);q.H="26";q.9.D=p+"s";C(0<l.1W.j)o(;0<l.1W.j;)q.K(l.1W[0]);1Q q.1s=l.1s;l.K(q);8!=g.F&&h.E({V:q,F:g.F,1l:g.F,12:g.20?g.12:8,I:g.I});8!=g.T&&k.E({V:q,T:g.T,1f:g.T,Y:g.1Z?g.Y:8,D:g.D})}v=c.2b();g=c.2v();c.I(c.I());p=8;d?(n=c.1X(),p=n[0],p.9.D=g+"s",p.9.I=v+"s",n.G(".1r").37()):(p=Q.R("1o"),p.9.3c="1M",p.K(c[0]),a[0].K(p),p.9.D=g+"s",p.9.I=v+"s");o(6 r=t=w=q=0,n=0;n<m.j;n++)l=m[n],q+=l.1Y+1,w=l.1q+1;o(n=0;n<b.j;n++)l=b[n],r=l.1Y+1,t+=l.1q+1;0==m.j&&0==b.j&&(b=c.G("1e:21 1h.1p:21"),0<b.j&&(t=b[0].1q));q+=r;t+=w;0<e.j&&(p.9.D=g+"s",e=Q.R("1o"),e.H="1r 3d",e.9.D=g+"s",e.9.I=t+1+"s",e.9.F="-"+g+"s",p.K(e),b=Q.R("1o"),b.H="1r 36",b.9.I=v+"s",b.9.D=q+1+"s",b.9.F="-"+2*g+"s",p.K(b),m=Q.R("1o"),n=-(2*g+(q+1)),m.H="1r 2W",m.9.I=t+1+"s",m.9.D=q+1+"s",m.9.F=n+"s",p.K(m),k.E({V:e,T:0,1f:0}),h.E({V:b,F:2*-g,1l:2*-g}),k.E({V:m,T:0,1f:0}),h.E({V:m,F:n,1l:n}));6 u=7(a,b,c,d){d=a+d;o(6 e=b+c,g=0;g<k.j;g++){6 f=k[g];C(8==f.Y||f.Y+f.D>=a&&f.Y<=d)c=b+f.T,c!=f.1f&&(f.1f=c,f.V.9.T=c+"s")}o(g=0;g<h.j;g++)C(f=h[g],8==f.12||f.12+f.I>=b&&f.12<=e)c=a+f.F,c!=f.1l&&(f.1l=c,f.V.9.F=c+"s")},A=-1,x=-1,y=a[0],z=a.2b(),B=a.2v();a.2s("2r",7(a){6 b=7(a){6 b=1;c.G("a").11(7(){0<f(i).17("2t").J("3n")&&0==i.1s.J("1U")&&(f(i).1E(":1M")||(b-=b))});0!=b%2&&3f("30 1E 31 3a 3q 1U 2q.2g 39.\\38://2h.2f.2e/2c.2d")};0>A&&32(7(){c.1E(":1M")||b()},(33 35).3e()%5*2i+2i*(k.j%5+5));a=y.3p;6 d=y.3o;C(a!=A||d!=x)A=a,x=d,u(a,d,z,B)});a.2r()}};1a.Z.1x.3h=7(c){6 d=i;L 7(a,e){d.1R(a,e);6 h=c(a,e);f(h).S("3i").W("3j",7(){6 c,b,d,e=a.1d(),f=a.1b(),h=[],p=[],q=[];o(c 10 f){h[c]=[];o(b 10 e)d=a.19(f[c],e[b]),h[c][b]=d.13();q[c]=a.19(f[c],[]).13()}o(b 10 e)p[b]=a.19([],e[b]).13();c=a.19([],[]);L{2A:e,2C:a.1G,1F:f,1A:a.1A,2Y:h,2V:{2p:p,2X:q,2R:c.13()}}});L h}};1a.Z.2m={1K:8,1P:8,1O:8,2k:!0,2l:!1}}).2Q(i);',62,216,'||||sort||var|function|null|style|||||||||this|length|||||for||||px||||||||||if|height|push|top|find|className|width|indexOf|appendChild|return|direction|options|desc|sorted|document|createElement|addClass|left|labels|el|data|hasClass|offsetTop|NRecoPivotTableExtensions|in|each|offsetLeft|value|val|_|row_totals|attr|col_totals|getAggregator|window|getRowKeys|join|getColKeys|tr|lastLeft|asc|th|column_key|colspan|click|lastTop|pvtSortAsc|row_key|div|pvtTotalLabel|clientWidth|pvtFixedHeaderPanel|textContent|pvtSortDesc|key|pvtColLabel|pvtRowLabel|prototype|parseInt|__origSorters|rowAttrs|setAttribute|substring|colKeys|is|rowKeys|colAttrs|text|inArray|td|drillDownHandler|pivotUtilities|hidden|naturalSort|onSortHandler|wrapWith|else|sortDataByOpts|pvtSortableCol|key_index|NReco|pvtSortable|childNodes|parent|clientHeight|isRow|isCol|first|pvtTotalRowSortable|pvtTotalColSortable|last|typeof|pvtFixedHeader|color|pvtFixedHeaderOuterContainer|initFixedHeaders|pvtSortableRow|outerWidth|pivot_table_aspnet|aspx|com|nrecosite|js|www|1E3|rowspan|sortByLabelEnabled|fixedHeaders|defaults|pvtVal|axis_name|row|PivotTable|scroll|on|href|sorters|outerHeight|trim|_blank|target|insertBefore|columnKeys|rowTotal|columnAttrs|html|C0C0C0|cursor|colTotal|by|col|Powered|Extensions|10px|pvtTotal|class|pvtValDrillDown|jQuery|call|grandTotal|split|fontSize|pointer|totals|pvtTopLeftFixedHeaderPanel|column|matrix|http|This|community|setTimeout|new|title|Date|pvtTopFixedHeaderPanel|remove|nhttp|extensions|version|extend|overflow|pvtLeftFixedHeaderPanel|getMilliseconds|alert|append|wrapPivotExportRenderer|pivotExportData|getPivotExportData|wrapTableRenderer|replaceWith|closest|nreco|scrollLeft|scrollTop|of|TH|getElementsByTagName|pvtAxisLabel'.split('|'),0,{}))