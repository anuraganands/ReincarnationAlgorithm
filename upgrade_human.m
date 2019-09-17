function [ ihuman ] = upgrade_human( ihuman, changed_soul, changed_karma, last_influence_marker )

    ihuman.soul = changed_soul;
    ihuman.karma = changed_karma;
    if (last_influence_marker > ihuman.specialized_marker)
        ihuman.specialized_marker = last_influence_marker;
    end
