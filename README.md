# Extraccion de datos Termicos


## Contexto 

## Descripcion de codigo 



### Datos de entrada 
La lectura de los datos en formato tabla (Excel, csv o txt) se hace en la linea 9 usando la funcion readmatrix.

Si los datos inician en la celda A1 no es necesario especificar un rango por lo que suponiendo que el archivo se llama Data.csv se deberia usar


```ruby
M = readmatrix('Data.csv');
```

En caso de que los datos se encuentren en otra seccion del archivo es necesario especificar el rango, por ejemplo en el siguiente caso los datos empiezan en la celda B2, esto puede pasar cuando las imagenes tienen etiquetas entonces la matriz con la informacion termica se mueve. 

```ruby
M = readmatrix('Data.csv','Range','B2:XQ481');
```

_Nota: Se debe configurar la separacion decimal como punto(.)_

Para la extracción de los datos de información térmica, se usa un algoritmo en Matlab que tiene como insumos las Imágenes Térmicas, RGB y el Excel con los valores térmicos, la imagen tiene un tamaño de 480x640, equivalente al tamaño de la matriz del archivo csv, la imagen termica se carga usando la funcion `imread` 

![Imagen Termica](https://github.com/Brayanjurado1325/Extraccion/blob/main/Imagenes/ImTer.png)



### Creacion de Mascara y extracccion de datos 
La variable que guarda la imagen termica (Tambien podria usarse la imagen RGB de referencia) se denomica Tem, para poder crear la mascara se usa las siguientes lineas de codigo, abriendo una figura donde se creara el borde de la figura de manera manual.  

   `figure`  
   `mascara = roipoly(Tem);`  
   `mascara = imcomplement(mascara);`  
   `imshow(mascara);`  
  
El resultado de se refleja en la variable mascara, una matriz binaria de 480x64. 

![Creacion de Mascara](https://github.com/Brayanjurado1325/Extraccion/blob/main/Imagenes/seleccionMas.png)

Para aplicar la mascara sobre la matriz del archivo csv (M) se usa la linea de codigo `M(mascara) = 0;`obteniendo como resultado una matiz de 480x640 que contiene los valores de temperatura en la mascara y 0 en los otros valores. 

![Aplicacion de MAscara](https://github.com/Brayanjurado1325/Extraccion/blob/main/Imagenes/Mascara.png)

Posteriormente la matriz M se convierte en una nube de puntos en X,Y,Z donde X y Y son las coordenadas y Z son los datos de temperatura, dando como resultado una nube de puntos que se almacena en la variable Data. 

![Extraccion de Data](https://github.com/Brayanjurado1325/Extraccion/blob/main/Imagenes/data.png)

Debido a la gran candida de puntos se usa la funcion `Data_muestra= datasample(Data,150)` para muestrear la variable y obtener un muestreo de los datos de temperatura. 

![Muestreo de datos](https://github.com/Brayanjurado1325/Extraccion/blob/main/Imagenes/Muestreo.png)

### Segmentacion de datos 

El algoritmo hace la clasificacion con me metodo de k-vecinos seccionando la panicula en 3 partes y dando un valor para cada seccion que debe registrarse de manera manual.

![Muestreo de datos](https://github.com/Brayanjurado1325/Extraccion/blob/main/Imagenes/clusterpanicula.png)



