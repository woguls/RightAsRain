<CsoundSynthesizer>
<CsOptions>
-odac
</CsOptions>
<CsInstruments>

sr = 44100
ksmps = 256
nchnls = 2
0dbfs = 1

;;channels
chn_k "mix2",3
chn_k "mix",3
chn_k "volume",3



        opcode PitchShift, aak, ak
ain, kshift   		xin            
areal, aimag            hilbert2 ain, 8192, 128
asin                    oscili 1, kshift / 2, 1
acos                    oscili 1, kshift / 2, 1, .25
amod1                 = areal * acos
amod2                 = aimag * asin
aupshift              = (amod1 - amod2) * 0.7
adownshift            = (amod1 + amod2) * 0.7

asinf, alock            plltrack aupshift , 0.1
krms                    rms aupshift
kpch                    init 200

	if ( k(asinf) < 800 && k(alock) > 3 ) then
		kpch = k(asinf) - kshift / 2
	endif
xout                    aupshift, adownshift, kpch
        endop

	     opcode BarModelPitch, aak, i
iK	     		xin
kbcL                  = 1
kbcR                  = 3
ib                    = 0.001
iT30                  = 15
ipos                  = random 0.1, 0.9

ivel                    random 800, 1000
iwid            	random 0.1, 0.9
iscan                   random 0.001, 0.05


abar                    barmodel kbcL, kbcR, iK, ib, iscan, iT30, ipos, ivel, iwid
abar                    atone abar , 40

abarL, abarR, kpch      PitchShift 0.5 * abar, 10
xout                    abarL, abarR, kpch
	     endop
	     
	     
        instr 3
gksinf                  init 200
gkArrayChanger 		init 0
gkArr[]                 fillarray 120, 90, 30, 60
                        turnoff
        endin
  
        instr 5
iK                    = p4
abarL, abarR, kpch      BarModelPitch iK
gksinf                = kpch 
outs                    abarL, abarR 
        endin
		

	instr 6
kfr                     port gksinf, 3
asin1                   oscili 1, kfr , 1
asin2			oscili 1, kfr + 20 , 1	
outs    		0.01 * asin1, 0.01 * asin2
	endin
		
		
	instr 1
anoise			fractalnoise 0.05, .05
anoisel                 fractalnoise 0.01, 2.5
knewbeat		randh 10, 0.09
knewbeat              = knewbeat + 5
kbeats			lineto knewbeat, 5
ktone                   init 0

	if gkArrayChanger == 0 then
			kv1      rand 5
			kv2      rand 5
			kv3      rand 5
			kv4      rand 5
			gkArr[]  fillarray 30 + kv1, 60 + kv2, 90 + kv3, 120 + kv4
	endif
	
ktrig    		metro .18
ktoneChange             init 0

        if ktoneChange == 0 then
                ktone = (ktone + 1)
                ktone = ktone % 4
        endif


schedkwhen 	        ktrig, 1, 30, 5, 0, 15, gkArr[ktone] 
	if ktrig == 1 then
		gkArrayChanger = ( gkArrayChanger + 1 ) 
		gkArrayChanger = gkArrayChanger % 24
		ktoneChange = (ktoneChange + 1) % 2
	endif

anl, anr, kpch1         PitchShift anoisel, kbeats

aleft, aright, kpch2	PitchShift anoise, 1.1 * kbeats


anl			tone anl, 60 
anr			tone anr, 60

aleft			tone aleft, 100
aright			tone aright, 100
kv			chnget "volume"
kv                    = kv * 3
km    			chnget "mix"
km2			chnget "mix2"
km2                   = 3 * km2


                        outs kv *(km2 * anl + km * aleft), kv * (km2 * anr +  km * aright)
	endin


		
</CsInstruments>
<CsScore>
f 1 0 16384 10 1
i3 0 .1
i1 0 2100
i6 0 2100

</CsScore>
</CsoundSynthesizer>
<bsbPanel>
 <label>Widgets</label>
 <objectName/>
 <x>0</x>
 <y>0</y>
 <width>216</width>
 <height>223</height>
 <visible>true</visible>
 <uuid/>
 <bgcolor mode="nobackground">
  <r>255</r>
  <g>255</g>
  <b>255</b>
 </bgcolor>
 <bsbObject type="BSBVSlider" version="2">
  <objectName>volume</objectName>
  <x>47</x>
  <y>123</y>
  <width>20</width>
  <height>100</height>
  <uuid>{480492e5-4f07-4347-8d86-f96814da027d}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>0</midicc>
  <description/>
  <minimum>0.00000000</minimum>
  <maximum>1.00000000</maximum>
  <value>0.36000000</value>
  <mode>lin</mode>
  <mouseControl act="jump">continuous</mouseControl>
  <resolution>-1.00000000</resolution>
  <randomizable group="0">false</randomizable>
 </bsbObject>
 <bsbObject type="BSBVSlider" version="2">
  <objectName>mix</objectName>
  <x>140</x>
  <y>123</y>
  <width>20</width>
  <height>100</height>
  <uuid>{f09cf76f-900b-4b3e-baf4-90f374193f2c}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>0</midicc>
  <description/>
  <minimum>0.00000000</minimum>
  <maximum>1.00000000</maximum>
  <value>0.22000000</value>
  <mode>lin</mode>
  <mouseControl act="jump">continuous</mouseControl>
  <resolution>-1.00000000</resolution>
  <randomizable group="0">false</randomizable>
 </bsbObject>
 <bsbObject type="BSBVSlider" version="2">
  <objectName>mix2</objectName>
  <x>196</x>
  <y>123</y>
  <width>20</width>
  <height>100</height>
  <uuid>{7902cf97-e66b-4afc-a847-f2bac06f634c}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>0</midicc>
  <description>mix2</description>
  <minimum>0.00000000</minimum>
  <maximum>1.00000000</maximum>
  <value>0.22000000</value>
  <mode>lin</mode>
  <mouseControl act="jump">continuous</mouseControl>
  <resolution>-1.00000000</resolution>
  <randomizable group="0">false</randomizable>
 </bsbObject>
</bsbPanel>
<bsbPresets>
</bsbPresets>
