package com.sequarius.generator.common;

import lombok.Data;

import java.util.List;
import java.util.Set;

/**
 * project titan
 *
 * @author Sequarius *
 * @since 04/02/2020
 */
@Data
public class GenerateSpec {

    private String entityName;
    private String displayName;
    private String moduleName;
    private String url;

    private String servicePackageName;
    private String projectRoot;
    private String basePackageName;
    private String domainPackageName;
    private String controllerPackageName;

    private Boolean overrideWhenFileExisted;
    private Boolean ignoreController;

    private Boolean ignoreSaveMethod;
    private Boolean ignoreUpdateMethod;
    private Boolean ignoreRemoveMethod;
    private Boolean ignoreListMethod;
    private Boolean ignoreGetMethod;

    private List<FieldSpec> fieldSpecs;

    private Set<String> fieldTypePackages;
}
