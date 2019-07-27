

TRIBES="tribe_ancient_dryads
tribe_antikamis
tribe_beachcombers
tribe_cholorogoos
tribe_cockroaches
tribe_first_deserter
tribe_gibbay
tribe_goo_heads
tribe_hamazans_of_the_dead_seed
tribe_keepers
tribe_lagoon_brothers
tribe_lawless
tribe_master_of_the_goo
tribe_matisian_border_guards
tribe_recoverers
tribe_renegades
tribe_sap_gleaners
tribe_scorchers
tribe_slavers
tribe_the_slash_and_burn
tribe_woven_bridles"

for tribe in $TRIBES
do
	grep $tribe faction_words_es.txt | cut -d$'\t' -f 3
done
