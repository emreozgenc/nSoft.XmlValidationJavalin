DOCUMENT
---

# xsd
## maindoc

##### Açıklama
Kullanıcı tarafına kolaylık sağlamak için sorunlulukları kaldırıldı

```xml
    <xsd:element ref="ext:UBLExtensions" minOccurs="0" maxOccurs="1"/>
    <xsd:element ref="cac:Signature" minOccurs="0" maxOccurs="unbounded"/>
```
---

## common
##### Açıklama
UBLExtensions complex type
```xml
<xsd:element ref="UBLExtension" minOccurs="0" maxOccurs="unbounded">
<xsd:element ref="ExtensionContent" minOccurs="0" maxOccurs="1">
```