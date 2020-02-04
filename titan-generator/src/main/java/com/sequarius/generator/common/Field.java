package com.sequarius.generator.common;

import lombok.AllArgsConstructor;
import lombok.Data;

/**
 * project titan
 *
 * @author Sequarius *
 * @since 04/02/2020
 */
@Data
@AllArgsConstructor
public class Field {
    private String name;

    private String displayName;

    private Integer length;

    private Class<?> type;
}
