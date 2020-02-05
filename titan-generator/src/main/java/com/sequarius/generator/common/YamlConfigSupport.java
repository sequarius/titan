package com.sequarius.generator.common;

import org.mybatis.generator.internal.util.StringUtility;
import org.yaml.snakeyaml.Yaml;
import org.yaml.snakeyaml.constructor.Constructor;

import java.io.InputStream;
import java.util.*;
import java.util.function.Function;
import java.util.stream.Collectors;

/**
 * project titan
 *
 * @author Sequarius *
 * @since 04/02/2020
 */
public class YamlConfigSupport {

    public GenerateSpec loadGenerateSpec(InputStream inputStream, Entity entity) {
        Yaml yaml = new Yaml(new Constructor(GenerateSpec.class));
        GenerateSpec spec = yaml.load(inputStream);
        initConfig(spec, entity);
        return spec;
    }

    private void initConfig(GenerateSpec spec, Entity entity) {
        if (!StringUtility.stringHasValue(spec.getEntityName())) {
            spec.setEntityName(entity.getName().replace("DO",""));
        }
        if (!StringUtility.stringHasValue(spec.getDisplayName())) {
            spec.setDisplayName(entity.getDisplayName());
        }

        Map<String, FieldSpec> specialConfig = new HashMap<>();
        List<FieldSpec> resultSpec = new LinkedList<>();
        Set<String> packageSet = new TreeSet<>();

        if (spec.getFieldSpecs() != null) {
            specialConfig = spec.getFieldSpecs().stream().collect(Collectors.toMap(FieldSpec::getName, Function.identity()));
        }
        for (Map.Entry<String, Field> entityFiled : entity.getFiledMap().entrySet()) {
            FieldSpec fieldSpec = specialConfig.get(entityFiled.getKey());
            if (fieldSpec == null) {
                fieldSpec = new FieldSpec();
                fieldSpec.setName(entityFiled.getValue().getName());
            }
            if (!StringUtility.stringHasValue(fieldSpec.getDisplayName())) {
                fieldSpec.setDisplayName(entityFiled.getValue().getDisplayName());
            }
            if (fieldSpec.getMaxLength() == null) {
                fieldSpec.setMaxLength(entityFiled.getValue().getLength());
            }
            fieldSpec.setType(entityFiled.getValue().getType());
            resultSpec.add(fieldSpec);
            String className = entityFiled.getValue().getType().getName();
            if(className.startsWith("java.lang")){
                continue;
            }
            packageSet.add(className);
        }
        spec.setFieldSpecs(resultSpec);
        spec.setFieldTypePackages(packageSet);
    }
}
