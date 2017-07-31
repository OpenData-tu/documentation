# Units of Measurement

**Authorship:**<br/>
Written by Andres<br/>
Discussion section written by Paul, proofread and edited by Andres


Since the same physical quantity can be represented in different units of measurement &mdash;both meters and miles represent lengths, for example&mdash; storing measurements of physical quantities inherently introduces the complexity of these different representations. While the topic is certainly quite interesting, especially when considering how sensors process and convert signals to digital values for a measurement, we shall limit the scope of our discussion here 1) to how our system deals with the different ways in which the same physical quantity can be represented, and 2) to the facilities provided to users by the system to convert their measurements from one unit to another.


## Requirements

From early on in the analysis phase, it became apparent that in order to deal with the heterogeneity of incoming data and to fulfill the requirement of providing a uniform query interface for the data, a global schema would have to be introduced and enforced all imported data. That is, someone who is performing a query would expect the data to be structurally and semantically consistent, even if it came from different sources. Say our platform offered ambient temperature readings; this data may come from different sensors manufactured by different companies and which provide data in different formats. In order for the data to be usable for analysis, I, as a data user, would not expect to have to convert readings from the U.S. to Celsius in order to be able to compare it with data from Europe, or from degrees Kelvin if a particular sensor manufacturer has calibrated its devices to report ambient temperature  in this unit.

Having standard units for a given physical quantity means, however, that data importers must take care to convert all units to the standard for the platform. In order to reduce friction for our data donators, we also wish to provide facilities to convert their units to those required by our system. With this in mind, we formalized our requirements with respect to units as follows:

* all measurement values stored and reported by our system must be accompanied by a unit of measurement
* any measurement values which underwent unit conversion must include information about the converter so that it may be reverted, if necessary
* provide extensible facilities to users to convert units within their importer packages to the required unit defined by the system for that physical quantity

## Survey of Previous Work

### Standards

#### ISO

ISO 1000 &ndash; *"SI units and recommendations for the use of their multiples and of certain other units"* was first introduced in 1981 and revised in 1992, but withdrawn and superseded by ISO(/DIN) 80000 in 2009. The standard is under the ISO/TC 12 technical committee, which is responsible for

> "Standardization of units and symbols for quantities and units (and mathematical symbols) used within the different fields of science and technology, giving, where necessary, definitions of these quantities and units. Standard conversion factors between the various units."

In addition, now-withdrawn ISO 2955:1983 *"Information processing -- Representation of SI and other units in systems with limited character sets"* deals with encoding unit symbols for machine processing.

 Unfortunately, ISO standards are not available free of charge, so their relevance and usefulness to our project could not be evaluated.


#### ANSI X3.50

The 1986 standard *"Representations for U.S. Customary, SI, and Other Units to Be Used in Systems with Limited Character Sets"* deals with the symbolic representation of the units, and as a result is not of particular interest to our objectives, namely:

> "This standard was not designed for [...] usage by humans as input to, or output from, data systems. [...] They should never be printed out for publication or for other forms of public information transfer."


#### NIST 811

The *Guide for the Use of the International System of Units (SI)* from 1995 and updated in 2008 provides a comprehensive reference regarding SI and units in general aimed to assist scientific paper authors from the National Institute of Standards and Technology (NIST). The guide proved useful in condensing the wealth of information that is SI and the variety of units and formats in an straight forward, complete yet concise document.


#### Unified Code for Units of Measure (UCUM)

Based on ISO 80000, UCUM's "purpose is to facilitate unambiguous electronic communication of quantities together with their units."  Like ISO 2955 and ANSI X3.50, its focus is on machine-to-machine communication and encoding of units. Unlike the latter two standards, which it claims contain numerous name conflicts and are incomplete, UCUM "provides a single coding system for units that is complete, free of all ambiguities, and that assigns to each defined unit a concise semantics."

The standard is in scope and of (limited) interest to our application


### Applications

#### GNU Units

String-based command-line application for converting units. Available as Linux and Windows binaries.


#### jScience

This library is, among others, an implementation of the UCUM standard mentioned prior. The library was part of a Java Specification Request (JSR) to be made part of the Java Standard Library under JSR-275, which was rejected in 2010.

The project itself is not in active development and can no longer be downloaded from their main site, as the source code and binaries were hosted in the now-defunct java.net platform.

#### JSR-363 &ndash; Units of Measurement API

Based on jScience (JSR-275), this library provides a rich programming interface to express quantities and units in Java. The proposal is on its way to being approved at the time of writing (July, 2017).


### Conclusions of Survey

The Units of Measurement API (JSR-363) is promising. However, given the fact that many such libraries have failed to gain noticeable traction in the past (at least in Java), and because we want to keep the learning curve for enthusiast data importers as low as possible, we consider this API to be too complex for the simple task at hand: to convert units.


## Implementation

### Converters

First, let us consider the `Serializable` Java interface. In serialization, the goal is to transform an in-memory object into a format which enables its state to be persisted, and conversely to re-create an object from this persisted state to an in-memory object again. To accomplish this, the interface requires one method to serialize the object, and one to deserialize, respectively. Additionally, because the serialization implementation may have changed between the time an object was serialized and when it will be deserialized, the interface imposes a version descriptor (simply a `static final long serialVersionUID` value ).

Our task is quite similar to serialization, not in that we seek to persist an object (which has attributes with values), but rather in that there is some process which renders a particular instance of a "thing" into a different *representation*; additionally, it's also able to reverse this process. Versioning is naturally of interest as well, since without some mechanism to revert a conversion, a faulty unit converter would permanently render converted measurements unusable and irrecoverable. A converter version would enable us then to revert incorrect conversions.

At its simplest, a unit converter could be expressed as:

```
public absrtact class UnitConverter {

    public abstract double convert(double source);
    public abstract double inverse(double source);
}
```

And an example Celsius-to-Farenheit converter:

```
public class CelsiusToFarenheitUnitConverter extends UnitConverter {
    @Override
    public double convert(double source) {
        return (source * 9d)/5d + 32;
    }

    @Override
    public double inverse(double source) {
        return (source - 32) * 5d/9d;
    }
}
```

The converters would be made available to the community and open for contributions. This can be achieved through a public version control system (such as Git), on which merge requests could be accepted.

## Discussion

**Authorship:** Written by Paul

This implementation has some advantages but also some disadvantages. In this section we want to take a closer look to both sides.

As we force the user to use our main unit, we ensure that all data in the database has the same unit for a given measurement type. Of course we cannot enforce that the user does indeed convert measurements correctly or at all, but this would be considered a faulty import, which in the end is the responsibility of the user. Of course an assessment of the correctness of data would be nice, but this is also hard to achieve and not within the scope of our project.

Our approach of having a curated list means some management overhead and possible longer implementation effort for the user if a unit conversion he or she needs is not yet available. Given the vast number of units in general and the lack of standardization in the way sensors report their data, giving a lot of latitude to the user to specify the units and the necessary conversions seems like the only reasonable way in which to approach the issue.

As the unit categories should be present after a short testing phase of a system, and a main unit exists with with, as the curators decide on one, the user should most of the time be able to register a source, when he wants to, as he only needs to know the main unit.

A big advantage of our approach is, that we kind of crowd-source the implementation of converters by this, as it happens during the ETL phase while importing (See //TODO ref chapter unit conversion) a source. This gives us a chance to achieve the following:

* Conversions can be reverted, as the converter used is stored with the data.
* Localization within our database can easily be done, as all measurements of a unit category have the same unit and converters are written the moment someone has to convert his source data to our preferred unit.
* By crowd-sourcing the implementation of converters they are also open sourced for reuse by other users. Having our own converters only in the system to convert measurements after they are in the database would not guarantee the reusability as importers and our database frontend depend on totally different things.


## Future Improvements

Our implementation in this regard is a proof of concept. The community-sourcing aspect remains to be implemented, though, as discussed, a public Git repository would be a feasible low-effort first alternative.
