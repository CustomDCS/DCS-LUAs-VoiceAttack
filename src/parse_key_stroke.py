import xml.etree.ElementTree as ET

def read_xml(filename):
    commands = []
    tree = ET.parse(filename)
    root = tree.getroot()

    ##Profile > Commands > Command > KeyCodes > unsignedShort
    for object_elem in root.Commands.findall('commands'):
        commands.append{object_elem} # each command should be it's own searchable section
        
    for command in commands:
        code = int(command.KeyCodes.unsignedShort.text)
        commands.command({'code': code})

    return commands


def modify_object_code(objects):
    for i in range(2, len(objects)):
        if (
            objects[i]['code'] == 112 and
            objects[i-1]['code'] == 121 and
            objects[i-2]['code'] == 220
        ):
            objects[i]['code'] = 113


def main():
    filename = 'src/oneCommand.xml'
    objects = read_xml(filename)

    # Print the list of objects
    for obj in objects:
        print(obj)

    modify_object_code(objects)
    print('-------------------')

    # Print modified list
    for obj in objects:
        print(obj)

if __name__ == '__main__':
    main()