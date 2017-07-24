
if(UNIX)
    set(CUDA_NVCC_FLAGS ${CUDA_NVCC_FLAGS}; -Xcompiler -fPIC; -O3; -ccbin ${CMAKE_CXX_COMPILER})
else()
    set(CUDA_NVCC_FLAGS ${CUDA_NVCC_FLAGS}; -ccbin "\"${CMAKE_CXX_COMPILER}\"")
endif()

IF (USE_GPU)
	file(GLOB_RECURSE gpu_SRCS "*.cu")
ENDIF()

set (darknet_SOURCES
	activation_layer.c  
	box.c         
	coco.c       
	connected_layer.c      
	crnn_layer.c  
	data.c                   
	dropout_layer.c  
	image.c     
	local_layer.c    
	nightmare.c            
	rnn.c          
	#server.c          
	tag.c      
	#yolo_demo.c
	activations.c       
	captcha.c     
	convolutional_layer.c  
	crop_layer.c  
	deconvolutional_layer.c  
	gemm.c           
	matrix.c         
	normalization_layer.c  
	rnn_layer.c    
	shortcut_layer.c  
	utils.c
	avgpool_layer.c     
	cifar.c       
	col2im.c     
	cost_layer.c           
	cuda.c        
	detection_layer.c        
	go.c             
	layer.c     
	maxpool_layer.c 
	option_list.c          
	rnn_vid.c      
	softmax_layer.c   
	writing.c
	blas.c              
	classifier.c  
	compare.c    
#	cpu_gemm.c             
	dice.c                   
	im2col.c         
	list.c      
	network.c        
	parser.c               
	route_layer.c  
	swag.c            
	yolo.c
     batchnorm_layer.c   
     detector.c
     gru_layer.c
     region_layer.c
     reorg_layer.c
     super.c
     tree.c
     voxel.c
		demo.c
	DarknetAPI/DarknetAPI
	DarknetAPI/DarknetAPIConversions
	DarknetAPI/DarknetDetection
)



include_directories( ${CMAKE_CURRENT_LIST_DIR} ${OPENCV_INCLUDE_DIR} ${RAPIDJSON_INCLUDE_DIR})
cuda_add_library (darknetLib ${darknet_SOURCES} ${gpu_SRCS} SHARED)
install(TARGETS darknetLib LIBRARY DESTINATION ${LIB_DESTINATION} ARCHIVE DESTINATION ${LIB_DESTINATION} RUNTIME DESTINATION ${LIB_DESTINATION})

file(GLOB filesA *.h)
file(GLOB filesB DarknetAPI/*.h)

install(FILES  ${filesA} DESTINATION  ${HEADER_DESTINATION})
install(FILES  ${filesB} DESTINATION  ${HEADER_DESTINATION}/DarknetAPI)






