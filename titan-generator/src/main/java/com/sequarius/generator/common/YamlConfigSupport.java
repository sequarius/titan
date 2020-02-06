package com.sequarius.generator.common;

import lombok.extern.slf4j.Slf4j;
import org.mybatis.generator.internal.util.StringUtility;
import org.yaml.snakeyaml.Yaml;
import org.yaml.snakeyaml.constructor.Constructor;

import java.io.InputStream;
import java.lang.reflect.InvocationTargetException;
import java.util.*;
import java.util.function.Function;
import java.util.stream.Collectors;

/**
 * project titan
 *
 * @author Sequarius *
 * @since 04/02/2020
 */
@Slf4j
public class YamlConfigSupport {

    public GenerateSpec loadGenerateSpec(InputStream inputStream,ClassLoader loader,String entityClassName) {
        Yaml yaml = new Yaml(new Constructor(GenerateSpec.class));
        GenerateSpec spec = yaml.load(inputStream);
        Entity entity = null;
        try {
            entity = new EntityFieldHelper().getEntity(loader,entityClassName ,
                    spec.getCommonPackageName()+".annonation.Filed",
                    spec.getCommonPackageName()+".annonation.Entity");
        } catch (ClassNotFoundException | NoSuchMethodException | InvocationTargetException | IllegalAccessException e) {
            log.error(e.getMessage(),e);
            return null;
        }
        initConfig(spec, entity);
        return spec;
    }

    private void initConfig(GenerateSpec spec, Entity entity) {
        if (!StringUtility.stringHasValue(spec.getEntityName())) {
            String entityName = entity.getName().replace("DO", "");
            spec.setEntityName(entityName);
        }

        spec.setCamelEntityName(Character.toLowerCase(spec.getEntityName().charAt(0))+spec.getEntityName().substring(1));
        spec.setDoEntityName(entity.getName());

        if (!StringUtility.stringHasValue(spec.getDisplayName())) {
            spec.setDisplayName(entity.getDisplayName());
        }

        Map<String, FieldSpec> specialConfig = new HashMap<>();
        List<FieldSpec> resultSpec = new LinkedList<>();
        Set<String> packageSet = new TreeSet<>();
        Set<String> searchableFieldSet = new TreeSet<>();

        if (spec.getFieldSpecs() != null) {
            specialConfig = spec.getFieldSpecs().stream().collect(Collectors.toMap(FieldSpec::getName, Function.identity()));
        }
        for (Map.Entry<String, Field> entityFiled : entity.getFiledMap().entrySet()) {
            // init common field
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

            // add format annotation if the field is Date field.
            String className = entityFiled.getValue().getType().getName();
            if("java.util.Date".equals(className)){
                packageSet.add("com.fasterxml.jackson.annotation.JsonFormat");
                packageSet.add("org.springframework.format.annotation.DateTimeFormat");
                packageSet.add(spec.getCommonPackageName()+".util.Constant");
                packageSet.add(spec.getCommonPackageName()+".util.FormatUtil");
            }
            packageSet.add(className);

            // get searchable field
            if(Boolean.TRUE.equals(fieldSpec.getSearchable())){
                if (fieldSpec.getType().getSimpleName().equals("String")) {
                    searchableFieldSet.add(fieldSpec.getName());
                }else{
                    log.warn("cant mark field {} as search key, only type of String can be generate yet!",fieldSpec.getName());
                }
            }

            // has deleted value should be update deleted field for delete
            if("deleted".equals(entityFiled.getKey())){
                spec.setFlagDelete(true);
            }
        }
        spec.setFieldSpecs(resultSpec);
        spec.setSearchableFieldNames(searchableFieldSet);
        spec.setFieldTypePackages(packageSet);
    }
}
