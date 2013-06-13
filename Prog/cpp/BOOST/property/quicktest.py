import myproperty

d = myproperty.dummy()

x = d.getx()
print x.key()
print x.value()

x.modify_value("3")
print x.key()
print x.value()

y = d.gety()
print y.key()
print y.value()

y.modify_value("12.34")
print y.key()
print y.value()

myproperty.setProperty("x", "42")
myproperty.setProperty("y", "56.78")
print x.value()
print y.value()
