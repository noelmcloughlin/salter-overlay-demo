# Demonstration: salter integration

status: immature

# Procedure

1. Fork your salt-project. For this demo I used a random, but excellent, salt-project at: https://github.com/eligundry/salt.eligundry.com and renamed to "salter-overlay-demo" to avoid confusion.

2. Make repo compatible with salter
```
 git clone https://github.com/eligundry/salt.eligundry.com salter-overlay-demo
 cd salter-overlay-demo/
 mv pillar configs/
 mv salt profiles
 mkdir scripts/
 curl -o scripts/overlay-salt.sh https://raw.githubusercontent.com/saltstack-formulas/salter/master/contrib/overlay-salt.sh
```

  Optionally this too (if you have bigger plans ;-)
```
 curl -o scripts/salter.sh https://raw.githubusercontent.com/saltstack-formulas/salter/master/salter.sh
```

3. Overlay salt-desktop (note: will also execute  salt-bootstrap - comment out that line if desired)
```
sudo bash ./scripts/overlay-salt.sh
```

# Use salter

Your states/pillars are now available to salter (demo)-

` sudo salter add 'media-center' -u eligundry `


# References:
 1. salt.eligundry.com: https://github.com/eligundry/salt.eligundry.com
 2. salter guide: https://github.com/saltstack-formulas/salter/blob/master/README.rst#integration-recommendation
