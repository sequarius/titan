package com.sequarius.generator.common;

import org.yaml.snakeyaml.Yaml;
import org.yaml.snakeyaml.constructor.Constructor;

import java.io.InputStream;

/**
 * project titan
 *
 * @author Sequarius *
 * @since 04/02/2020
 */
public class YamlConfigSupport {

    public GenerateSpec loadGenerateSpec(InputStream inputStream){
        Yaml yaml = new Yaml(new Constructor(GenerateSpec.class));
        GenerateSpec spec = yaml.load(inputStream);
        return spec;
    }
}
