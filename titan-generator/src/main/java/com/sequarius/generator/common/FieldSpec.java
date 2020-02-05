package com.sequarius.generator.common;

import lombok.Data;

/**
 * project titan
 *
 * @author Sequarius *
 * @since 04/02/2020
 */
@Data
public class FieldSpec {
    private String name;
    private String displayName;

    private Boolean requestDTOIgnore;
    private Boolean responseDTOIgnore;

    private Boolean notNull;

    private Integer maxLength;
    private Integer minLength;
    private String defaultValue;
    private String regPatten;
    private String regPattenMessage;

    private Class<?> type;
}
