# Kreiranje objekta simulatora (inicijalizacija raspoređivača događaja)
set ns [new Simulator]

# Uključivanje trace procesa (kreiranje trace datoteke za vizualizaciju)
set nf [open out1.nam w]
$ns namtrace-all $nf

# Otvaranje trace datoteke za upis značajnih podataka o simulaciji
set tf [open out1.tr w]
$ns trace-all $tf

#Define a 'finish' procedure
proc finish {} {
        global ns nf tf
        $ns flush-trace
        # Zatvaranje NAM trace datoteke za vizualizaciju
        close $nf
        # Zatvaranje trace datoteke
        close $tf
        # Izvršavanje NAMa na trace datoteci
        exec nam out1.nam &
        exit 0
}

# Kreiranje čvorova
set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]
set n4 [$ns node]
set n5 [$ns node]


# Nodes Label
$n0 label "Čvor 0"
$n1 label "Čvor 1"
$n2 label "Čvor 2"
$n3 label "Čvor 3"
$n4 label "Čvor 4"
$n5 label "Čvor 5"


#Izgledi čvorova
$n0 color Red
$n1 color Green
$n2 color Purple
$n3 color Grey
$n4 color Blue
$n5 color Yellow


# Povezivanje čvorova duplex linkom
$ns duplex-link $n0 $n2 625kbit 3ms DropTail
$ns duplex-link $n2 $n1 384kbit 2ms DropTail
$ns duplex-link $n2 $n4 256kbit 1ms DropTail
$ns duplex-link $n1 $n3 256kbit 1ms RED
$ns duplex-link $n4 $n3 384kbit 2ms RED
$ns duplex-link $n3 $n5 625Mbit 3ms RED


#Položaj čvorova za izgled u NAM-u
$ns duplex-link-op $n0 $n2 orient right-up
$ns duplex-link-op $n2 $n1 orient up
$ns duplex-link-op $n2 $n4 orient right
$ns duplex-link-op $n1 $n3 orient right
$ns duplex-link-op $n4 $n3 orient up
$ns duplex-link-op $n3 $n5 orient right-up

# Kreiranje UDP transportnih agenata
set udp1 [new Agent/UDP]
$ns attach-agent $n0 $udp1
set null1 [new Agent/Null]
$ns attach-agent $n5 $null1
$ns connect $udp1 $null1
$udp1 set fid_ 1

set udp2 [new Agent/UDP]
$ns attach-agent $n0 $udp2
set null2 [new Agent/Null]
$ns attach-agent $n3 $null2
$ns connect $udp2 $null2
$udp2 set fid_ 2
#Kreirani tokovi tok1 i tok2

# Postavljanje eksponencijalnog generatora saobra¢aja za prvi tok
set exp [new Application/Traffic/Exponential]
$exp set type_ Exponential
$exp set packet_size_ 700
$exp set burst_time_ 30ms
$exp set idle_time_ 65ms
$exp set rate_ 800k
$exp attach-agent $udp1

# Postavljanje Pareto generatora za drugi tok
set par [new Application/Traffic/Pareto]
$par set type_ pareto
$par set packet_size_ 350
$par set burst_time_ 500ms
$par set idle_time_ 500ms
$par set rate_ 200k
$par set shape_ 1.5
$par attach-agent $udp2


# Postavljanje scenarija simulacije
$ns at 1 "$par start"
$ns at 8 "$par stop"

$ns at 1 "$exp start"
$ns at 8 "$exp stop"

$ns at 10 "finish"


# Pokretanje simulacije
$ns run

