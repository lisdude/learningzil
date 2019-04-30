version = .z5

src = $(wildcard *.zil)
obj = $(src:.zil=.zap)
final = $(src:.zil=$(version))

%.zap: %.zil
	zilf $<

$(final): $(obj)
	zapf $<

.PHONY: clean

run:
	frotz $(final)

clean:
	rm $(final) ; rm *.zap ; rm *.xzap
