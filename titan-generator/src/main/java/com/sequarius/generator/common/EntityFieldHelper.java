package com.sequarius.generator.common;

import java.lang.annotation.Annotation;
import java.lang.reflect.InvocationTargetException;
import java.util.LinkedHashMap;
import java.util.Map;

/**
 * project titan
 *
 * @author Sequarius *
 * @since 04/02/2020
 */
public class EntityFieldHelper {

    public Entity getEntity(ClassLoader classLoader, String entityClassName, String filedAnnotationName,
                            String entityAnnotationName) throws ClassNotFoundException, NoSuchMethodException,
            InvocationTargetException, IllegalAccessException {
        Entity entity = new Entity();
        Map<String, Field> fieldMap = new LinkedHashMap<>();
        Class<?> entityClass = classLoader.loadClass(entityClassName);

        for (Annotation entityAnnotation : entityClass.getDeclaredAnnotations()) {
            Class<? extends Annotation> annotationClass = entityAnnotation.annotationType();
            if (!entityAnnotationName.equals(annotationClass.getName())) {
                continue;
            }
            entity.setName((String) annotationClass.getMethod("name").invoke(entityAnnotation));
            entity.setDisplayName((String) annotationClass.getMethod("displayName").invoke(entityAnnotation));
        }

        for (java.lang.reflect.Field declaredField : entityClass.getDeclaredFields()) {
            for (Annotation filedAnnotation : declaredField.getAnnotations()) {
                Class<? extends Annotation> annotationClass = filedAnnotation.annotationType();
                if (!filedAnnotationName.equals(annotationClass.getName())) {
                    continue;
                }
                String filedName = (String) annotationClass.getMethod("name").invoke(filedAnnotation);
                Field filed = new Field(
                        filedName,
                        (String) annotationClass.getMethod("displayName").invoke(filedAnnotation),
                        (Integer) annotationClass.getMethod("length").invoke(filedAnnotation),
                        declaredField.getType());
                fieldMap.put(filedName, filed);
            }
        }
        entity.setFiledMap(fieldMap);
        return entity;
    }

}
