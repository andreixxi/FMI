import bpy
from math import *

verts = []
edges = []
faces = []

u_strips = 20
u_steps = []
for i in range(0,u_strips+1):
    t = i/u_strips * 2 * pi
    u_steps.append(t)

v_strips = 10
v_steps = []
for i in range(0,v_strips+1):
    t = i/v_strips * 2 - 1
    v_steps.append(t)

for u in u_steps :
    for v in v_steps :
        x = (1 + ((v/2) * cos(u/2))) * cos(u)
        y = (1 + ((v/2) * cos(u/2))) * sin(u)
        z = (v/2) * sin(u/2)
        verts.append([x,y,z])
        

for i in range(0,u_strips) :
    for j in range(0,v_strips) :
        t1=i*(v_strips+1) + j
        t2=i*(v_strips+1) + j+1
        t3=(i+1)*(v_strips+1) + j+1
        t4=(i+1)*(v_strips+1) + j
        faces.append([t1,t2,t3,t4])

mesh = bpy.data.meshes.new("Shape")
obj = bpy.data.objects.new("Shape", mesh)
bpy.context.view_layer.active_layer_collection.collection.objects.link(obj)
mesh.from_pydata(verts,edges,faces)
mesh.update(calc_edges=True)
bpy.context.view_layer.objects.active = obj
obj.select_set(True)
bpy.ops.object.mode_set(mode='EDIT')
bpy.ops.mesh.remove_doubles()
bpy.ops.mesh.normals_make_consistent(inside=False)
bpy.ops.object.mode_set(mode='OBJECT')
mesh.use_auto_smooth = True
bpy.ops.object.shade_smooth()