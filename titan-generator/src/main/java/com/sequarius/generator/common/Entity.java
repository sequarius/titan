package com.sequarius.generator.common;

import lombok.Data;

import java.util.Map;

/**
 * project titan
 *
 * @author Sequarius *
 * @since 04/02/2020
 */
@Data
public class Entity {

    private String name;

    private String displayName;

    private Map<String, Field> filedMap;

}
