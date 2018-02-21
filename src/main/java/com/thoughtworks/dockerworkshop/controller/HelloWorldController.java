package com.thoughtworks.dockerworkshop.controller;

import org.springframework.web.bind.annotation.*;
import reactor.core.publisher.Flux;

import java.time.Duration;

@RestController
@RequestMapping(path = "/hello-world")
public class HelloWorldController {
    public static class Person {
        public final String name;

        public Person(String name) {
            this.name = name;
        }
    }

    @GetMapping(path = "/{namesByComma}", produces = "application/stream+json")
    public Flux<Person> onAskForHelloWorld(@PathVariable String namesByComma) {
        return Flux.fromArray(namesByComma.split(","))
                .delayElements(Duration.ofSeconds(1))
                .map(Person::new);
    }
}
